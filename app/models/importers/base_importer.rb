# frozen_string_literal: true

require 'csv'

# rubocop:todo Lint/Debugger: there are several instances of binding.pry here within rescue blocks.
# It's possible they are being used to discover issues during real prod imports and removing them
# would also require removing the rescue blocks; otherwise they would swallow errors.
# Leaving this as a todo to be cleaned up.

class Importers::BaseImporter # rubocop:todo Metrics/ClassLength
  attr_accessor :row_count, :new_records_count, :dupe_records_count, :row_success_count, :row_error_count

  def initialize(current_user)
    require "#{Rails.root}/db/scripts/tuple_counts.rb"
    audit_info(current_user)
    set_klasses
    establish_counts

    @log = ''
    @translations = translations
  end

  def audit_info(current_user)
    # @current_organization = current_user&.organization  # TODO
    @current_user = current_user # || User.guest_user(@current_organization)  # TODO
    puts '========'
    puts @current_user&.name
    # puts @current_organization&.name  # TODO
    puts '========'
  end

  def establish_counts
    @row_count = 0
    @row_success_count = 0
    @row_error_count = 0
    @new_records_count = 0
    @dupe_records_count = 0
    @row_processing_error_messages = []
    @counts_hash = {row_count: @row_count,
                    row_success_count: @row_success_count,
                    new_records_count: @new_records_count,
                    dupe_records_count: @dupe_records_count,
                    row_error_count: @row_error_count}
    @initial_model_logs = ''
    @initial_model_counts = {}
    @final_diff_model_counts = {}
  end

  def set_klasses
    @klasses_array = klasses_array
    @primary_klass_name = primary_import_klass_name
    puts '========PRIMARY IMPORT CLASS: '
    puts @primary_klass_name
    puts ' ========'
  end

  def required_fields_array
    [] ### define at child class level
  end

  def is_row_header(row)
    false ### define at child class level
  end

  def is_row_skip(row)
    row['to_import'] && row['to_import'].downcase == 'n'
  end

  def row_processing_requirement(row) # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    results = []
    required_fields_array.map do |rr|
      if rr.instance_of?(Array)
        if rr.map { |r| row[r] }.any?
          results << true
        else
          rr.map do |r|
            if !row[r].present?
              @row_processing_error_messages << "ERROR IN ROW#:#{@row_number}: row[#{r}] NOT PRESENT +++"
            end
          end
        end
      elsif row[rr].present?
        results << true
      else
        @row_processing_error_messages << "ERROR IN ROW#:#{@row_number}: row[#{rr}] NOT PRESENT +++"
        results << false
      end
    end
    results.all? ### can be overridden at child class level
  end

  def klasses_array
    [] ### define at child class level
  end

  def primary_import_klass_name
    @klasses_array.last.model_name.human # assuming last klass in array is the imported class (and show diff in flash message)
  end

  def set_instance_variables(row)
    ### define at child class level
  end

  def process_headers_as_data(rows)
    # define at child class level
  end

  def process_row(row)
    ### define at child class level
  end

  def import(path)
    Rails.logger.info("START IMPORT------------#{Time.now}")
    records_report('initial')

    rows = CSV.read(path, headers: true)
    import_rows(rows)
  end

  def import_string(string)
    Rails.logger.info("START IMPORT------------#{Time.now}")
    records_report('initial')

    rows = CSV.parse(string, headers: true)
    import_rows(rows)
  end

  def import_rows(rows) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    process_headers_as_data(rows)

    ActiveRecord::Base.transaction do
      puts "START------------#{Time.now}"
      set_instance_variables(rows.first)

      rows.each_with_index do |row, idx|
        @row_number = idx
        unless is_row_header(row) || is_row_skip(row) || row.values_at.compact.empty?
          @row_processing_error_messages = []
          if row_processing_requirement(row)
            begin
              process_row(row)
              @row_success_count += 1
            rescue => e
              puts e
              # binding.pry #### USE FOR TESTING IMPORTERS
              create_history_log(row, "PROCESS ROW ERROR IN ROW##{@row_number}: #{e}")
              @row_error_count += 1
            end
          else
            create_history_log(row, "ROW PROCESSING ERROR IN ROW##{@row_number}: #{@row_processing_error_messages.join(" +++ ")}")
            @row_error_count += 1
          end
          @row_count += 1
        end
      end
      records_report('final')
    end
  end

  def translations
    {}
  end

  def records_report(status) # rubocop:todo Metrics/MethodLength
    if status == 'initial'
      initial_model_counts
    end
    Rails.logger.info('---------')
    Rails.logger.info(@initial_model_counts)
    Rails.logger.info('---')
    if status == 'final'
      final_diff_model_counts
    end
    Rails.logger.info(@final_diff_model_counts)
    Rails.logger.info('---')
    Rails.logger.info(@counts_hash)
    Rails.logger.info('---------')
    @counts_hash
  end

  def initial_model_counts # rubocop:todo Metrics/MethodLength
    logs = []
    initial_counts_hash = {}
    @klasses_array.compact.each do |klass|
      klass_name = klass.model_name.human
      count = klass.count
      log = "INITL: #{klass_name} count: #{count}"
      logs << log
      initial_counts_hash[klass_name] = count
    end
    Rails.logger.info(pp(logs))
    @initial_model_logs = logs
    @counts_hash['INITIAL COUNTS'] = initial_counts_hash
    @initial_model_counts = initial_counts_hash
  end

  def final_diff_model_counts # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    final_logs = []
    diff_logs = []
    final_counts_hash = {}
    diff_counts_hash = {}
    @initial_model_counts.each do |klass_name, initial_count|
      begin
        klass = klass_name.parameterize.underscore.classify.constantize
        current_count = klass.count
      rescue => e
        puts "#{klass_name} is not a class"
        binding.pry
      end

      diff = current_count - initial_count
      final_counts_hash[klass_name] = current_count
      diff_counts_hash[klass_name] = diff
      final_log = "FINAL: #{klass_name} count: #{current_count}"
      diff_log = "+DIFF: #{klass_name} +diff: #{diff}"
      final_logs << final_log
      diff_logs << diff_log
    end
    Rails.logger.info(pp(@initial_model_logs))
    Rails.logger.info(pp(final_logs))
    Rails.logger.info(pp(diff_logs))

    @counts_hash['FINAL COUNTS'] = final_counts_hash
    @counts_hash['+DIFF COUNTS'] = diff_counts_hash

    @new_records_count = diff_counts_hash[@primary_klass_name]
    @final_diff_model_counts = final_counts_hash
  end

  def create_history_log(row, error_message = nil)
    extra_detail = [
      '+++ row_number#: ',
      @row_number.to_s,
      " +++ #{history_log_name(row.to_s)}",
      " +++ #{row}",
      " +++ DID NOT IMPORT -- #{error_message}  -- imported by #{@current_user&.name}"
    ].join
    HistoryLog.generate_import_log!(@current_user, self.class, extra_detail) # TODO
  rescue
    binding.pry
  end

  def history_log_name(row)
    " +++ name: #{row["name"]}" ### can be overwritten at class level
  end

  def destroy_records(today_only: false) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    ActiveRecord::Base.transaction do
      @klasses_array.each do |model|
        if model == Person
          Person.where.not("email ILIKE 'admin%' OR email ILIKE 'mutual%'").destroy_all
        else
          records = if today_only
            model.where("created_at::text ILIKE '#{Time.zone.today.strftime('%Y-%m-%d')}%'")
          else
            model.all
          end
          records.each do |object_instance|
            if object_instance.can_destroy?
              puts '==='
              puts object_instance.class
              puts object_instance.id
              object_instance.destroy!
            end
          end
        end
      end
    end
  end
end

def parse_date(date_string) # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
  date = nil
  if date_string&.include?('/')
    m, d, y = date_string.split('/')
    y, t = y.to_s.split(/\s+/)

    y = "20#{y}" if y.length == 2
    if Date.valid_date?(y.to_i, m.to_i, d.to_i)
      date = Date.new(y.to_i, m.to_i, d.to_i)
    else
      begin
        date = date_string.to_date # TODO: - add exception?
      rescue => e
        binding.pry ### USE FOR TESTING IMPORTERS
      end
    end
  elsif date_string&.include?('-')
    begin
      date = date_string.to_date # TODO: - add exception?
    rescue => e
      binding.pry ### USE FOR TESTING IMPORTERS
    end
  end
  date
end
# rubocop:enable Lint/Debugger
