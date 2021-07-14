# frozen_string_literal: true

class Importers::CustomFormQuestionImporter < Importers::BaseImporter
  def klasses_array
    [CustomFormQuestion]
  end

  def primary_import_klass_name
    'CustomFormQuestion'
  end

  def required_fields_array
    ['question_name']
  end

  def is_row_header(row)
    row['question_name'] && row['question_name'].downcase.include?('question_name')
  end

  def find_dupes_through_translations(value)
    CustomFormQuestion.i18n.where(name: value)
  end

  def find_or_create_custom_form_question(row) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    locale = row['locale'] || 'en' # rubocop:todo Lint/UselessAssignment
    form_type = row['form_type']
    input_type = row['input_type'] || 'string'
    is_required = YAML.load(row['is_required'].to_s)
    display_order = row['display_order'].present? ? row['display_order'].to_i : 10
    hint_text = row['hint_text']
    option_list = row['option_list'].present? ? row['option_list'].split(';') : []
    name = row['question_name']
    form_hook = row['form_hook']

    dupes_query = find_dupes_through_translations(name)
    if dupes_query.any?
      @log = 'GOT DUPE'
      @dupe_records_count += 1
      custom_form_question = dupes_query.last
    else
      @log = 'CREATED'
      custom_form_question = CustomFormQuestion.create!(
        form_type: form_type,
        input_type: input_type,
        is_required: is_required,
        display_order: display_order,
        hint_text: hint_text,
        option_list: option_list,
        form_hook: form_hook
      )
      @new_records_count += 1
    end
    custom_form_question
  end

  def process_row(row)
    valid_row = row['question_name'].present? ? true : false

    if valid_row
      custom_form_question = find_or_create_custom_form_question(row)
      puts "#{@log} CFQ --------#{custom_form_question&.name}-------------"
    end
  end

  def history_log_name(row)
    " +++ custom_form_question: #{row['question_name']}"
  end
end
