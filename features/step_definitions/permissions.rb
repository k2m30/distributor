require 'capybara/rails'

When(/^user visits (.*) controller pages with name = (.+) that belong to (.*)/) do |controller, name, username|
  #GET	      /admin/posts	          index	    admin_posts_path
  #GET	      /admin/posts/new	      new	      new_admin_post_path
  #POST	      /admin/posts	          create	  admin_posts_path
  #GET	      /admin/posts/:id	      show	    admin_post_path(:id)
  #GET	      /admin/posts/:id/edit	  edit	    edit_admin_post_path(:id)
  #PATCH/PUT	/admin/posts/:id	      update	  admin_post_path(:id)
  #DELETE	    /admin/posts/:id	      destroy 	admin_post_path(:id)

  id = User.find_by_username(username).groups.find_by_name(name).id
  @pages = get_paths_hash(controller, id)

  @current_controller = controller
  @results = Hash.new

  @pages.keys.each do |p|
    begin
      visit @pages[p]
      @results[p] = !(page.text.downcase.include?('error') || current_path == root_path || page.text.downcase.include?('couldn'))
    rescue => e
      p e.inspect
    end
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
      @results[p].should == expected_value(action)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      visit @pages[p]
      p page.text
      raise StandardError, 'User: ' + @username + '. '+ @pages[p] + '. ' + e.message
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
  expect(page).to have_content 'Стоп лист'
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