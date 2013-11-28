require 'mechanize'
require 'nokogiri'

Given(/^wrong credentials$/) do
  @username = 'ydachnik'
  @password = '111111'
end

When(/^user tries to log in$/) do
  @agent = Mechanize.new
  page = @agent.get('http://localhost:3000')
  form = page.forms.first
  form.field('user[username]').value = @username
  form.field('user[password]').value = @password
  @result_page = form.submit
end

Then(/^he fails$/) do
  page = Nokogiri::HTML @result_page.body
  page.at_css('.alert').content.include?('Неверный адрес email или пароль')
end

Then(/^on settings page he sees all of the buttons$/) do
  page = @agent.get('http://localhost:3000/settings')
  page.forms.size == 3
end

And(/^user credentials$/) do
  @username = 'ydachnik'
  @password = '123QWEasd'
end

Then(/^he sees settings page$/) do
  @result_page.uri.to_s.include?('settings')
end

Then(/^he sees stop_list page$/) do
  @result_page.uri.to_s.include?('stop_list')
end

Given(/^admin credentials$/) do
  @username = 'ydachnik'
  @password = '123QWEasd'
end