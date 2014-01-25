When(/^my (.*) updates$/) do |site_name|
  @site = Site.find_by_name site_name
  @site.update_prices
end


Then(/^it is updated properly$/) do
  @site.urls.size.should be > 0
  @site.urls.size.should be <= @site.items.size
  Log.joins(:site).where('site' => @site).size.should be > 1
end

And(/^real sites are imported$/) do
  @real_user = User.find_by_username('real_user')
  if @real_user.nil?
    @real_user = User.create(username: 'real_user', email: 'user@real.by', password: '123QWEasd')
    @real_user.all_sites_import('./import/ydachnik/all_sites.xlsx')
    @real_user.standard_site_import('./import/ydachnik/standard.xlsx')
    @real_user.shops_file_import('./import/ydachnik/shops.xlsx')

    p 'new data imported'
  end
expect(@real_user).not_to be_nil
end