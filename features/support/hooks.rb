#prepare testing db

#Site.delete_all
#Item.delete_all
#Group.delete_all
#Url.delete_all
#Log.delete_all
#User.delete_all
#Settings.delete_all

@test_user = User.find_by_username('test_user') || User.create!(username: 'test_user', email: 'office@test.by', password: '123QWEasd')
p @test_user.username

#@test_user.all_sites_import('./import/ydachnik/all_sites.xlsx')
#@test_user.standard_site_import('./import/ydachnik/standard.xlsx')
#@test_user.shops_file_import('./import/ydachnik/shops.xlsx')

p Group.all.size
p Site.all.size
p Item.all.size

Before('@outline') do |scenario|
  p scenario.scenario_outline.name + scenario.name
end
Before('@scenario') do |scenario|
  p scenario.name
end

at_exit do

end
