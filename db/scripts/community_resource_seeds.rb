require 'csv'

csv = "community_resources.csv"
path = Rails.root.join('db', 'seeds', 'public_template_csvs', csv)
importer = Importers::CommunityResourceImporter.new(User.first)
importer.import(path)

puts "completed community_resources.csv"
