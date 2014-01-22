def prepare_test_db
  p 'prepare testing db'
  DatabaseCleaner.clean

  @test_user = User.find_by_username('test_user') || User.create(username: 'test_user', email: 'user@test.by', password: '123QWEasd')
  @test_user.all_sites_import('./import/test_data/test_user/all_sites.xlsx')
  @test_user.standard_site_import('./import/test_data/test_user/standard.xlsx')
  @test_user.shops_file_import('./import/test_data/test_user/shops.xlsx')

  @test_admin = User.create(username: 'test_admin', email: 'admin@test.by', password: '123QWEasd', admin: true)
  @test_admin.standard_site_import('./import/test_data/test_admin/standard.xlsx')
  @test_admin.shops_file_import('./import/test_data/test_admin/shops.xlsx')

end

p User.all.pluck(:id, :username)
p Group.all.pluck(:id, :name)
p Site.all.order(:name).pluck(:name)
p Item.count


Before('@outline') do |scenario|
  p scenario.scenario_outline.name + scenario.name
end
Before('@scenario') do |scenario|
  p scenario.name
end

Before('@no_db_clean') do
  DatabaseCleaner.strategy = nil
  #prepare_test_db
  @test_admin = User.find_by_username('test_admin') || prepare_test_db

end

Before('@db_clean') do
  DatabaseCleaner.strategy = :truncation
  p 'db_clean started'
end

After('@db_clean') do
  p 'db_clean finished'
end



at_exit do

end
