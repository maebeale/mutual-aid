# frozen_string_literal: true

require 'csv'

desc 'Extra db functions: stats_check, reset db with seeds, import csv and seed data'

namespace :db do
  task rebuild_and_seed_dev: [
    'db:reset',
    'db:migrate',
    'db:import_all_seeds',
    'db:stats_check'
  ]

  task rebuild_and_seed: [
    'db:reset',
    'db:migrate',
    'db:seed',
    'db:stats_check'
  ]

  task recreate_all_seeds: [
    'db:truncate_tables',
    'db:import_all_seeds',
    'db:stats_check'
  ]

  task import_all_seeds: [
    'db:seed',
    'db:import_dev_seeds',
    'db:import_submission_response_seeds',
    'db:import_user_seeds',
    'db:import_custom_form_question_seeds',
    'db:stats_check'
  ]

  task stats_check: :environment do
    require "#{Rails.root}/db/scripts/tuple_counts.rb"
  end

  task truncate_tables: :environment do
    require "#{Rails.root}/db/scripts/truncate_tables.rb"
  end

  task import_dev_seeds: :environment do
    require "#{Rails.root}/db/seeds/dev_seeds.rb"
  end

  # use seed files stored in repo for easy templating of private files
  task import_submission_response_seeds: :environment do
    require "#{Rails.root}/db/scripts/submission_response_seeds.rb"
  end

  task import_user_seeds: :environment do
    require "#{Rails.root}/db/scripts/user_seeds.rb"
  end

  task import_custom_form_question_seeds: :environment do
    require "#{Rails.root}/db/scripts/custom_form_question_seeds.rb"
  end

  task :import_community_resource_seeds => :environment do
    require "#{Rails.root}/db/scripts/community_resource_seeds.rb"
  end
end
