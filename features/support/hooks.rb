Before do |scenario|
  #p scenario.scenario_outline.name + scenario.name
end

#p User.first.inspect
#@user = User.first || User.create!(username: 'ydachnik', email: 'office@ydachnik.by', password: '123QWEasd')
#p @user.inspect
#@user.all_sites_import('./import/ydachnik/all_sites.xlsx')
#@user.standard_site_import('./import/ydachnik/standard.xlsx')
#@user.shops_file_import('./import/ydachnik/shops.xlsx')
#p Group.all.size
#p Site.all.size
#p Item.all.size