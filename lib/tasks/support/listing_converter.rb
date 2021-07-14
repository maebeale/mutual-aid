# frozen_string_literal: true

class ListingConverter
  def convert listing
    Listing.transaction do
      first_tag_set, *remaining_tag_sets = splitter.split listing.tag_list

      listing.update! tag_list: [first_tag_set]

      remaining_tag_sets.map do |tag_set|
        listing.dup.tap do |new_listing|
          new_listing.update!(tag_list: tag_set, created_at: listing.created_at)
        end
      end
    end
  end

  def splitter
    @splitter ||= TagSplitter.new
  end

  class TagSplitter
    attr_reader :lineages

    def initialize lineages = nil
      @lineages = lineages || gather_lineages
    end

    def gather_lineages
      Category.all.map { |category| [category.name, category.lineage] }.to_h
    end

    def split tag_list
      matching_lineages = lineages
        .values_at(*tag_list)
        .sort_by { |lineage| lineage.size }
        .reverse

      matching_lineages.reduce([]) do |minimal_set, lineage|
        with_lineage = minimal_set + [lineage]
        with_lineage.flatten.uniq.size > minimal_set.flatten.uniq.size ? with_lineage : minimal_set
      end
    end
  end
end
