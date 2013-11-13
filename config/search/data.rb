require 'rubygems'
require 'open-uri'
require 'rubyXL'

group = 'GROUP'
site = 'SITE'
item = 'ITEM'

##############import BOSCH###############

data_bosch = RubyXL::Parser.parse('/Users/Mikhail/RubymineProjects/distibutor/config/search/data_bosch.xlsx')
table_item = data_bosch[0].get_table(['GROUP', 'ITEM'])
table_item.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [item]
  end
end
table_site = data_bosch[1].get_table(['GROUP', 'SITE'])
table_site.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [site]
  end
end

##############import MTD###############

data_mtd = RubyXL::Parser.parse('/Users/Mikhail/RubymineProjects/distibutor/config/search/data_mtd.xlsx')
table_item = data_mtd[0].get_table(['GROUP', 'ITEM'])
table_item.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [item]
  end
end
table_site = data_mtd[1].get_table(['GROUP', 'SITE'])
table_site.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [site]
  end
end

#############import KARCHER###############
puts '-------'
data_karcher = RubyXL::Parser.parse('/Users/Mikhail/RubymineProjects/distibutor/config/search/data_karcher.xlsx')
table_ite = data_karcher[0].get_table(['GROUP', 'ITEM'])
table_ite.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [item]
  end
end
table_sit = data_karcher[1].get_table(['GROUP', 'SITE'])
table_sit.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [site]
  end
end

##############import ELPUMS###############
puts '-------'
data_elpums = RubyXL::Parser.parse('/Users/Mikhail/RubymineProjects/distibutor/config/search/data_elpums.xlsx')
table_item = data_elpums[0].get_table(['GROUP', 'ITEM'])
table_item.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [item]
  end
end
table_site = data_elpums[1].get_table(['GROUP', 'SITE'])
table_site.values[0].each do |hash|
  if !hash.empty?
    puts hash [group] + ' ' + hash [site]
  end
end