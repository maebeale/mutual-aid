class AdminDashboardController < AdminController
  def show # rubocop:todo Metrics/AbcSize
    @submission_count = Submission.count
    @match_count = Match.any? ? Match.pluck(:receiver_id).uniq.length : 1
    @ask_count = Ask.any? ? Ask.all.length : 1
    @offer_count = Offer.any? ? Offer.all.length : 1
    @percent_offers_fulfilled = ((@match_count.to_f / @offer_count.to_f).to_f * 100).to_i
    @percent_asks_fulfilled = ((@match_count.to_f / @ask_count.to_f).to_f * 100).to_i
    @asks_unmatched_count = Ask.unmatched.length
    @offers_unmatched_count = Offer.unmatched.length
    @announcements_pending_count = Announcement.pending_review.length
    @community_resources_pending_count = CommunityResource.pending_review.length
  end
end
