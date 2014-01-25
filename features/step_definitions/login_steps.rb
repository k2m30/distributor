require 'mechanize'
require 'nokogiri'

Then(/^he fails$/) do
  expect(page).not_to have_content 'Стоп лист'
end

Then(/^he sees stop_list page$/) do
  expect(page).to have_content 'Стоп лист'
end