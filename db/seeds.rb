# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[Site, Item, Url].each do |table|
  table.delete_all
end

############################# SITES ########################
site = Site.new
site.name = "50.by"
site.regexp = "<span class=\"price\">(.*)<span class=\"currency\">руб.</span></span>"
site.save
puts site.inspect

site = Site.new
site.name = "vitrina.shop.by"
site.regexp = "\" title=\"купить\">(.*)руб.</a>"
site.save
puts site.inspect

site = Site.new
site.name = "krama.by"
site.regexp = "\t\t\t\t\t\t\t\t\.?(.*)руб"
site.save
puts site.inspect

site = Site.new
site.name = "stroitel.shop.by"
site.regexp = "\" title=\"купить\" class=\"ye\">(.*)руб.</a>"
site.save
puts site.inspect

site = Site.new
site.name = "ydachnik.by"
site.regexp = "<div class=\"cat_price_product\">Цена:(.*)руб.</div>"
site.save
puts site.inspect

################################ ITEMS MTD 46 PO###################
item = Item.new
item.name = "MTD 46 PO"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-46-po"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-MTD-SMART-46-PO/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/3513/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3942/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1740"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS  MTD 990 AST ###################
item = Item.new
item.name = "MTD 990 AST"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/benzinovyj-trimmer-mtd-990-ast"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Trimmer-benzinovyy-MTD-990-AST/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/7008/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/benzinovie_trimmeri/benzotrimmeri_MTD/3935/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=109"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

item.save