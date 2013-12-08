When(/^my (.*) updates$/) do |site_name|
  @site = Site.find_by_name site_name
  p site_name
  p Site.all.count
  #@site.update_prices
end


Then(/^it is updated properly$/) do
  #(@site.urls.size > 0) && (@site.urls.size <= @site.items.size) && (@site.logs.size > 1)
  true
end

Then(/^all data are loaded$/) do
  @user.all_sites_import('./import/ydachnik/all_sites.xlsx')
  @user.standard_site_import('./import/ydachnik/standard.xlsx')
  @user.shops_file_import('./import/ydachnik/shops.xlsx')
  p 'Data loaded'

  (@user.groups.size > 0) &&
  !Site.joins(:groups).where(standard: true, groups: {'user' =>  @user}).uniq.empty? &&
  !Item.all.empty?
end