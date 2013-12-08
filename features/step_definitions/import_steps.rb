require 'roo'
require 'rspec/expectations'

Given(/^user is ydachnik$/) do
  @user = User.create!(username: 'ydachnik', email: 'office@ydachnik.by', password: '123QWEasd')
end

And(/^no sites exist$/) do
  Site.delete_all
  Item.delete_all
  Group.delete_all
  Url.delete_all
  Log.delete_all
end

When(/^user tries to import all sites xlsx file$/) do
  import_all_sites_file('./import/ydachnik/all_sites.xlsx')
end

Then(/^there are no groups created$/) do
  @groups_delta.should == 0
end

And(/^there are no items created$/) do
  @items_delta.should == 0
end

And(/^sites numbers increases to total number of rows on all sheets in file$/) do
  spreadsheet = Roo::Excelx.new(@filename)
  @sites_delta.should == spreadsheet.last_row-1
end

And(/^there are no sites created$/) do
  @sites_delta.should == 0
end

And(/^sites exist$/) do
  Site.all.size.should > 0
end

def import_all_sites_file(filename)
  sites_count_before = Site.all.size
  items_count_before = Item.all.size
  groups_count_before = Group.all.size

  @filename = filename
  @user.all_sites_import(@filename)

  sites_count_after = Site.all.size
  items_count_after = Item.all.size
  groups_count_after = Group.all.size

  @sites_delta = sites_count_after - sites_count_before
  @items_delta = items_count_after - items_count_before
  @groups_delta = groups_count_after - groups_count_before
end

def import_standard_site_file(filename)
  sites_count_before = Site.all.size
  items_count_before = Item.all.size
  groups_count_before = Group.all.size

  @filename = filename
  @user.standard_site_import(@filename)

  sites_count_after = Site.all.size
  items_count_after = Item.all.size
  groups_count_after = Group.all.size

  @sites_delta = sites_count_after - sites_count_before
  @items_delta = items_count_after - items_count_before
  @groups_delta = groups_count_after - groups_count_before
end

def import_shops_file(filename)
  sites_count_before = Site.all.size
  items_count_before = Item.all.size
  groups_count_before = Group.all.size

  @filename = filename
  @user.shops_file_import(@filename)

  sites_count_after = Site.all.size
  items_count_after = Item.all.size
  groups_count_after = Group.all.size

  @sites_delta = sites_count_after - sites_count_before
  @items_delta = items_count_after - items_count_before
  @groups_delta = groups_count_after - groups_count_before
end
When(/^user tries to import standard site xlsx file$/) do
  import_standard_site_file('./import/ydachnik/standard.xlsx')
end

Then(/^groups are created$/) do
  spreadsheet = Roo::Excelx.new(@filename)
  @groups_delta.should == spreadsheet.sheets.size
end

And(/^items are created$/) do
  spreadsheet = Roo::Excelx.new(@filename)
  items_in_file = 0
  spreadsheet.sheets.each do |sheet|
    items = spreadsheet.column(3, sheet).select {|item| !item.nil?}
    items_in_file += items.size-1
  end
  @items_delta.should == items_in_file
end

And(/^standard site is created$/) do
 !Site.joins(:groups).where(standard: true, groups: {'user' =>  @user}).uniq.empty?.should == true
end

When(/^user tries to import shop xlsx file$/) do
  import_shops_file('./import/ydachnik/shops.xlsx')
end

Then(/^user groups contain sites from file$/) do
  spreadsheet = Roo::Excelx.new(@filename)
  spreadsheet.sheets.each do |sheet|
    spreadsheet.default_sheet = sheet
    group = Group.where(name: sheet, 'user' => @user).first
    group.nil?.should_not == true
    p [group.name, 'сайтов:', group.sites.size]
    group.sites.size.should == (Site.all.map(&:name) & spreadsheet.column(1, sheet)).size + 1
  end
end


And(/^standard site is in every group$/) do
  @user.groups.each do |group|
    group.sites.where(standard: true).size.should == 1
  end
end