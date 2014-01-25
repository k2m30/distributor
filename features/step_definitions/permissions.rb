require 'capybara/rails'

When(/^user visits (.*) controller pages with name = (.+) that belong to (.*)/) do |controller, name, username|
  #GET	      /admin/posts	          index	    admin_posts_path
  #GET	      /admin/posts/new	      new	      new_admin_post_path
  #POST	      /admin/posts	          create	  admin_posts_path
  #GET	      /admin/posts/:id	      show	    admin_post_path(:id)
  #GET	      /admin/posts/:id/edit	  edit	    edit_admin_post_path(:id)
  #PATCH/PUT	/admin/posts/:id	      update	  admin_post_path(:id)
  #DELETE	    /admin/posts/:id	      destroy 	admin_post_path(:id)

  id = get_id(controller, name, username)
  @pages = get_paths_hash(controller, id)

  @current_controller = controller
  @results = Hash.new

  @pages.keys.each do |p|
      visit @pages[p]
      @results[p] = !(page.text.downcase.include?('error') || current_path == root_path || page.text.downcase.include?('couldn'))
  end
end

def get_id(controller, name, username)
  case controller
    when 'groups'
      User.find_by_username(username).groups.find_by_name(name).id
    when 'sites'
      Site.find_by_name(name).id
    when 'items'
      Item.joins(:group => :user).where(name: name, groups: {'user_id'=> User.find_by_username(username).id}).first.id
    else
      2
  end

end

def get_paths_hash(controller, id)
  return {'index' => "/#{controller}",
   'new' => "/#{controller}/new",
   'show' => "/#{controller}/#{id}",
   'edit' => "/#{controller}/#{id}/edit"}
end

But(/^he (.*) see (.*) page\(s\)$/) do |action, pages|
  pages.gsub(' ', '').split(',').each do |p|
    begin
      expect(@results[p]).to be(expected_value(action)), "#{@username} |  #{@pages[p]} | expected #{expected_value(action)} , got #{@results[p].to_s} "
    #rescue RSpec::Expectations::ExpectationNotMetError => e
      #visit @pages[p]
      #p page.text
      #raise StandardError, "#{@username} |  #{@pages[p]} | #{e.message} "
    end

  end
end

def expected_value(action)
  expected_value = action=='can' ? true : false
end

And(/^user logs in$/) do
  visit new_user_session_path

  fill_in 'user[username]', :with => @username
  fill_in 'user[password]', :with => @password

  click_on 'form_submit'
end

Given(/^(.*) credentials$/) do |user|
  @username = user
  @password = '123QWEasd'
end

When(/^he sees (\d+) elements with css = '(.*)'$/) do |total, css|
  page.all(css).size.should == total.to_i
end

When(/^user visits (.*) page$/) do |p|
  visit @pages[p]
end

When(/^he should not see text (.*)$/) do |text|
  expect(page).not_to have_content text
end

Then(/^he should see text (.*)$/) do |text|
  expect(page).to have_content text
end

And(/^test_data import is done$/) do
  @test_user = User.find_by_username('test_user')

  if @test_user.nil?
    @test_user = User.create(username: 'test_user', email: 'user@test.by', password: '123QWEasd')
    @test_user.all_sites_import('./import/test_data/test_user/all_sites.xlsx')
    @test_user.standard_site_import('./import/test_data/test_user/standard.xlsx')
    @test_user.shops_file_import('./import/test_data/test_user/shops.xlsx')

    @test_admin = User.create(username: 'test_admin', email: 'admin@test.by', password: '123QWEasd', admin: true)
    @test_admin.standard_site_import('./import/test_data/test_admin/standard.xlsx')
    @test_admin.shops_file_import('./import/test_data/test_admin/shops.xlsx')
  end

end