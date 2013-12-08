When(/^my (.*) updates$/) do |site_name|
  @site = Site.find_by_name site_name
  @site.update_prices
end


Then(/^it is updated properly$/) do
  @site.urls.size.should be > 0
  @site.urls.size.should be <= @site.items.size
  Log.joins(:site).where('site' => @site).size.should be > 1
end

Given(/^user is test_user$/) do
  @user = @test_user
end