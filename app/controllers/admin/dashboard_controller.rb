class Admin::DashboardController < Admin::ApplicationController
  def index
    @banners_count = Banner.count
    @lotteries_count = Lottery.count
    @members_count = Member.count
    @payments_count = Payment.count
    # @articles_count = Article.count
  end
end
