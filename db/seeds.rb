# coding: utf-8
require 'rubygems'
require 'open-uri'
require 'rubyXL'

####################### import ###############
a = 0
p "Started"
workbook = RubyXL::Parser.parse("import.xlsx")

sheets = [workbook.worksheets[0]]
sheets.each do |sheet|
  group = Group.where(name: sheet[0][0].value).first
  data = sheet.extract_data
  data[1..data.size].each_with_index do |row, i|
    row[1..row.size].each_with_index do |col, j|
      site = group.sites.where(name: sheet[0][j+1].value).first
      # p "---" + sheet[0][j+1].value
      if site.nil?
        p "-" + sheet[0][j+1].value.to_s
      end

      item = Item.where(name: sheet[i+1][0].value).first #item
      if item.nil?
        p sheet[i+1][0].value
      end

      cell_value = sheet[i+1][j+1].value
      url = (item.nil? || site.nil?) ? nil : get_url(item, site)

      if !url.nil?
        url.url = cell_value #url
        url.site = Site.where(name: site.name).first

        if !item.sites.include?(url.site)
          item.sites << url.site
          item.save
        end
        if !url.site.items.include?(item)
          url.site << item
          url.site.save
        end
        if !url.site.groups.include?(item.group)
          url.site.groups << item.group
          url.site.save
        end
        a += 1
        url.save


        if url.site.name == "ydachnik.by"
          puts "----"
          puts url.id, url.item.name, cell_value
          p url.site.urls.find(url.id).url
          p url.item.urls.find(url.id).url, url.url
          puts "----"
        end

        if url.url == "X" || url.url == "[]" || url.url.nil?
          site.urls -=[url]
          item.urls -=[url]
          url.delete
        end

      else

        if !(cell_value == "X" || cell_value == "[]" || cell_value.nil?)
          url = Url.new
          url.site = site
          url.item = item
          url.url = cell_value
          url.save
        end

      end

    end
  end

end

Url.all.each do |url|
  if !url.site.groups.include?(url.item.group)
    url.site.groups << url.item.group
    url.site.save
  end
end

p a
p "Finished"



############################## site_css_xpath ########################
# group = "GROUP"
# site = "SITE"
# css = "CSS"
# xpath = "XPATH"
# cssname = "CSSNAME"
#
# file = RubyXL::Parser.parse("site_css_xpath.xlsx")
#
# table_site = file[0].get_table([group, site, css, xpath,cssname])
# #puts table_site.inspect
# table_site.values[0].each do |hash|
#   if !hash.empty?
#     site_array = Site.where("name = ?", hash[site])
#     site_array.each do |site_base|
#       site_base.css = hash[css]
#       site_base.xpath = hash[cssname]
#       #site_base.cssname = hash[cssname]
#       puts site_base.name + ' ' + site_base.css
#       site_base.save
#     end
#   end
# end
#
#[Group, Site, Item, Url].each do |table|
#  table.delete_all
#end
############################## GROUPS ########################
#group = Group.new
#group.name = "MTD"
#group.user = User.all[0]
#group.save
#
#group = Group.new
#group.name = "BOSCH"
#group.user = User.all[0]
#group.save
#
#group = Group.new
#group.name = "KARCHER"
#group.user = User.all[0]
#group.save
#
#group = Group.new
#group.name = "ELPUMS"
#group.user = User.all[0]
#group.save
#
###############import MTD###############
#group = "GROUP"
#site = "SITE"
#item = "ITEM"
#file = RubyXL::Parser.parse("data_mtd.xlsx")
#
#table_item = file[0].get_table(["GROUP", "ITEM"])
#group_base = Group.where(:name => table_item.values[0][0][group]).first
#table_item.values[0].each do |hash|
#  if !hash.empty?
#     item_base = Item.new
#     item_base.name = hash[item].gsub(hash[group]+" ","")
#     item_base.group = group_base
#     item_base.save
#  end
#end
#
#table_site = file[1].get_table(["GROUP", "SITE"])
#group_base = Group.where(:name => table_site.values[0][0][group]).first
#table_site.values[0].each do |hash|
#  if !hash.empty?
#    site_base = Site.new
#    site_base.name = hash[site]
#    site_base.groups << group_base
#    site_base.save
#  end
#end
#
###############import KARCHER###############
#group = "GROUP"
#site = "SITE"
#item = "ITEM"
#file = RubyXL::Parser.parse("data_karcher.xlsx")
#
#table_item = file[0].get_table(["GROUP", "ITEM"])
#group_base = Group.where(:name => table_item.values[0][0][group]).first
#table_item.values[0].each do |hash|
#  if !hash.empty?
#    item_base = Item.new
#    item_base.name = hash[item].gsub(hash[group]+" ","")
#    item_base.group = group_base
#    item_base.save
#  end
#end
#
#table_site = file[1].get_table(["GROUP", "SITE"])
#group_base = Group.where(:name => table_site.values[0][0][group]).first
#table_site.values[0].each do |hash|
#  if !hash.empty?
#    site_base = Site.new
#    site_base.name = hash[site]
#    site_base.groups << group_base
#    site_base.save
#  end
#end
#
###############import ELPUMS###############
#group = "GROUP"
#site = "SITE"
#item = "ITEM"
#file = RubyXL::Parser.parse("data_elpums.xlsx")
#puts file.inspect
#table_item = file[0].get_table(["GROUP", "ITEM"])
#puts table_item.inspect
#group_base = Group.where(:name => table_item.values[0][0][group]).first
#puts group_base.inspect
#table_item.values[0].each do |hash|
#  if !hash.empty?
#    item_base = Item.new
#    item_base.name = hash[item].gsub(hash[group]+" ","")
#    item_base.group = group_base
#    item_base.save
#  end
#end
#
#table_site = file[1].get_table(["GROUP", "SITE"])
#group_base = Group.where(:name => table_site.values[0][0][group]).first
#table_site.values[0].each do |hash|
#  if !hash.empty?
#    site_base = Site.new
#    site_base.name = hash[site]
#    site_base.groups << group_base
#    site_base.save
#  end
#end
#
###############import BOSCH###############
#group = "GROUP"
#site = "SITE"
#item = "ITEM"
#file = RubyXL::Parser.parse("data_bosch.xlsx")
#puts file.inspect
#table_item = file[0].get_table(["GROUP", "ITEM"])
#puts table_item.inspect
#group_base = Group.where(:name => table_item.values[0][0][group]).first
#puts group_base.inspect
#table_item.values[0].each do |hash|
#  if !hash.empty?
#    item_base = Item.new
#    item_base.name = hash[item].gsub(hash[group]+" ","")
#    item_base.group = group_base
#    item_base.save
#  end
#end
#
#table_site = file[1].get_table(["GROUP", "SITE"])
#group_base = Group.where(:name => table_site.values[0][0][group]).first
#table_site.values[0].each do |hash|
#  if !hash.empty?
#    site_base = Site.new
#    site_base.name = hash[site]
#    site_base.groups << group_base
#    site_base.save
#  end
#end
#
#
#
############################## SETTINGS ########################
##s = Settings.new
##s.user = User.all[0]
##s.save
#
############################### SITES ########################
##site = Site.new
##site.name = "50.by"
##site.regexp = "<span class=\"price\">(.*)<span class=\"currency\">руб.</span></span>"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "vitrina.shop.by"
##site.regexp = "\" title=\"купить\">(.*)руб.</a>"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "krama.by"
##site.regexp = "\t\t\t\t\t\t\t\t\.?(.*)руб"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "stroitel.shop.by"
##site.regexp = "class=\"ye\">(.*)руб.</"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "ydachnik.by"
##site.regexp = "<div class=\"cat_price_product\">Цена:(.*)руб.</div>"
##site.standard = true
##site.groups << group
##site.save
##puts site.inspect
##
###site = Site.new
###site.name = "21vek.by"
###site.regexp = "<span class = ' g-price item__price cr-price__in'>(.*)<span class = 'g-price__unit item__priceunit'>руб.</span></span>"
###site.save
###puts site.inspect
##
##site = Site.new
##site.name = "mir-mtd.by"
##site.regexp = "<br>\.?(.*)&nbsp;"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "gepard.by"
##site.regexp = "[\"n]>.?\n\t\t\t\t\t\t\t\t\t(.*)руб."
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "suseki.by"
##site.regexp = "<div class=\"price\">(.*) <span>руб.</span></div>"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "mirbt.by"
##site.regexp = "<span class=\"secondPrice\">(.*)руб.</span>"
##site.groups << group
##site.save
##puts site.inspect
##
##site = Site.new
##site.name = "7sotok.by"
##site.regexp = "price\">.\?.\?\n\t\t\t\t<span>(.*)руб</span>"
##site.groups << group
##site.save
##puts site.inspect
##
##
################################## ITEMS  MTD 990 AST ###################
##item = Item.new
##item.name = "MTD 990 AST"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/benzinovyj-trimmer-mtd-990-ast"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Trimmer-benzinovyy-MTD-990-AST/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/7008/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/benzinovie_trimmeri/benzotrimmeri_MTD/3935/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=109"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_990_ast.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/trimmery/trimmer-mtd-990-ast"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/624"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
################################## ITEMS  MTD 827 AST ###################
##item = Item.new
##item.name = "MTD 827 AST"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Trimmery-benzinovyye-/Trimmer-benzinovyy-MTD-827-AST/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/22109/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/benzinovie_trimmeri/benzotrimmeri_MTD/mtd_827_ast/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1728"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/trimmery/mtd-827-ast"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/garden-trimmers/mtd/trimmer-benzinovyy-mtd-827/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_827_ast.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##
##item.save
##
################################## ITEMS  MTD 1033 AST ###################
##item = Item.new
##item.name = "MTD 1033 AST"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Trimmery-benzinovyye-/Trimmery-benzinovyye-mtd-/Trimmer-benzinovyy-MTD-710-AST/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/8865/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1831"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_1033.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 1043 AST###################
##item = Item.new
##item.name = "MTD 1043 AST"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Trimmery-benzinovyye/Trimmery-benzinovyye-mtd/8434/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/7007/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1832"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_1043.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 32 E###################
##item = Item.new
##item.name = "MTD 32 E"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Gazonokosilki-elektricheskiye-/Gazonokosilki-elektricheskiye-MTD-/Gazonokosilka-elektricheskaya-MTD-SMART-32-E/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/17279/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1738"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_electro_gazon/mtd_electro_gazon/89.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-32-e"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-smart-32-e/?sphrase_id=27213"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 38 E###################
##item = Item.new
##item.name = "MTD 38 E"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilki-elektricheskiye/Gazonokosilka-elektricheskaya-MTD-SMART-38-E/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/17280/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Elektrogazonokosilki/Elektrogazonokosilki_MTD/16872/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1739"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_electro_gazon/mtd_electro_gazon/mtd_smart_38_e.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-38-e"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-smart-38-e/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 395 PO###################
##item = Item.new
##item.name = "MTD 395 PO"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-395-po"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-nesamokhodnaya-MTD-395-PO/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/7010/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3941/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=80"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_395_po.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-395-po"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-benzinovaya-mtd-395-po/?sphrase_id=27211"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_benzinovaya_mtd_395_po/?sphrase_id=27211"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 46 PO###################
##item = Item.new
##item.name = "MTD 46 PO"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-46-po"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-MTD-SMART-46-PO/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/3513/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3942/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1740"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_po.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-46-po"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-46-po-smart/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/56"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 46 PB###################
##item = Item.new
##item.name = "MTD 46 PB"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/-gazonokosilka-nesamohodnaya-benzinovaya-mtd-46-pb"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-MTD-OPTIMA-46-PB/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18107/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3943/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1741"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_pb.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-46-pb"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-46-pb-optima/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/69"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 46 SPO###################
##item = Item.new
##item.name = "MTD 46 SPO"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spo"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPO/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/3514/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3944/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1742"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_spo.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-46-spo"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-46-spo-smart/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/92"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 46 SPB###################
##item = Item.new
##item.name = "MTD 46 SPB"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spb"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPB/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/20360/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3946/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1743"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_spb.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-46-spb"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-46-spb-optima/?sphrase_id=27216"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/70"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 46 SPB HW###################
##item = Item.new
##item.name = "MTD 46 SPB HW"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spb-hw"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPB-HW/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6997/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3947/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1746"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/62.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-46-spb-hw"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-46-spb-hw-optima/?sphrase_id=27216"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 51 BO###################
##item = Item.new
##item.name = "MTD 51 BO"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-51-bo"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-nesamokhodnaya-MTD-51-BO/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6998/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3940/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=79"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_51_bo.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-51-bo"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-benzinovaya-mtd-51-bo/?sphrase_id=27221"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/57"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 53 SPO###################
##item = Item.new
##item.name = "MTD 53 SPO"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/benzinovaya-samohodnaya-gazonokosilka-mtd-53-spo"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-53-SPO/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6996/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3948/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1749"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spo.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-53-spo"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-53-spo-smart/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/91"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 53 SPB###################
##item = Item.new
##item.name = "MTD 53 SPB"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-53-SPB/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/9142/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3949/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1748"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spb.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-53-spb"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-53-spb-optima/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/71"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 53 SPB HW###################
##item = Item.new
##item.name = "MTD 53 SPB HW"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/benzinovaya-samohodnaya-gazonokosilka-mtd-53-spb-hw"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Gazonokosilki-benzinovyye-samokhodnyye-/Gazonokosilka-benzinovaya-samokhodnaya-MTD-53-SP-CWH/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18112/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/10114/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1747"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spb_hw.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-53-spb-hw"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-53-spb-hw-optima/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 53 SPK HW###################
##item = Item.new
##item.name = "MTD 53 SPK HW"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-53-spk-hw"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-ADVANCE-53-SPK-HW/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18108/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/14621/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spk_hw.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-53-spk-hw"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-53-spk-hw-advance/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD 53 SPKV HW###################
##item = Item.new
##item.name = "MTD 53 SPKV HW"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-ADVANCE-53-SPKV-HW/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6995/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/mtd_advance_53_spkv_hw/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1775"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_advance_53_spkv_hw.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-advance-53-spkv-hw"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka-mtd-53-spkv-hw-advance/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD SMART RC 125###################
##item = Item.new
##item.name = "MTD SMART RC 125"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-rc-125"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Minitraktory/Minitraktor-MTD-SMART-RC-125/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/10878/17278/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/mtd_smart_rc_125/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1154"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_rc_125.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/mtd-smart-rc-125"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/101"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD OPTIMA LE 155H###################
##item = Item.new
##item.name = "MTD OPTIMA LE 155H"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-le-155-h"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Minitraktory/Rayder-minitraktor-MTD-OPTIMA-LE-155-H-RTG/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/10878/MTD_155_H_RTG/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1242"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_le_155_h.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/minitraktor-mtd-le-155-h"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD OPTIMA LN 200 H###################
##item = Item.new
##item.name = "MTD OPTIMA LN 200 H"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-ln-200-h"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Minitraktory/Rayder-minitraktor-MTD-OPTIMA-LE-200-H-RTG/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/10878/18118/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1243"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_ln_200_h.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/mtd-optima-ln-200-h-rtg"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD Т/205###################
##item = Item.new
##item.name = "MTD Т/205"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/kultivator-benzinovyj-mtd-t205"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-205/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/8868/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/4401/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=489"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_205.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-205"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator-benzinovyy-mtd-t205/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t205/"
##url.site_id = Site.where("name = ?", "mirbt.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t205/"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD Т/245###################
##item = Item.new
##item.name = "MTD Т/245"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/kultivator-benzinovyj-mtd-t245"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-245/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/6991/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/4407/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=115"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_245.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-245"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator-benzinovyy-mtd-t245/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/26112/"
##url.site_id = Site.where("name = ?", "mirbt.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/234"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD T/330 M###################
##item = Item.new
##item.name = "MTD T/330 M"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/kultivator-mtd-t330-m"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-330-M/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/8776/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/4409/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=116"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_330_m.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-330-m"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator-benzinovyy-mtd-t-330-m/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t330/"
##url.site_id = Site.where("name = ?", "mirbt.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/search/4/330"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD T/330 B###################
##item = Item.new
##item.name = "MTD T/330 B"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/kultivator-mtd-t-330-b-700"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-330/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/20082/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=1347"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_330_m_bs.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-330"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator-benzinovyy-mtd-t-330-b-700/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/view/241"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
##
################################## ITEMS MTD T/380 M###################
##item = Item.new
##item.name = "MTD T/380 M"
##item.group_id = group.id
##
##url = Url.new
##url.url = "http://50.by/products/kultivator-mtd-t380-m"
##url.site_id = Site.where("name = ?", "50.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-380-M/"
##url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/9382/"
##url.site_id = Site.where("name = ?", "krama.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/9145/"
##url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.ydachnik.by/catalog/?id=483"
##url.site_id = Site.where("name = ?", "ydachnik.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_380_m.html"
##url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-380-m"
##url.site_id = Site.where("name = ?", "gepard.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator-benzinovyy-mtd-t-380-m/"
##url.site_id = Site.where("name = ?", "suseki.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t380/"
##url.site_id = Site.where("name = ?", "mirbt.by").first.id
##item.urls << url
##url.save
##
##url = Url.new
##url.url = "http://7sotok.by/pages/product/search/4/380"
##url.site_id = Site.where("name = ?", "7sotok.by").first.id
##item.urls << url
##url.save
##
##item.save
