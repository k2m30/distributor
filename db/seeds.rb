# coding: utf-8
[Group, Site, Item, Url].each do |table|
  table.delete_all
end
############################# GROUPS ########################
group = Group.new
group.name = "MTD"
group.user = User.all[0]
group.save

############################# SETTINGS ########################
s = Settings.new
s.user = User.all[0]
s.save

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
site.regexp = "class=\"ye\">(.*)руб.</"
site.save
puts site.inspect

site = Site.new
site.name = "ydachnik.by"
site.regexp = "<div class=\"cat_price_product\">Цена:(.*)руб.</div>"
site.save
puts site.inspect

#site = Site.new
#site.name = "21vek.by"
#site.regexp = "<span class = ' g-price item__price cr-price__in'>(.*)<span class = 'g-price__unit item__priceunit'>руб.</span></span>"
#site.save
#puts site.inspect

site = Site.new
site.name = "mir-mtd.by"
site.regexp = "<br>\.?(.*)&nbsp;"
site.save
puts site.inspect

site = Site.new
site.name = "gepard.by"
site.regexp = "-usd\">\.?\n\t\t\t\t\t\t\t\t\t(.*)руб\."
site.save
puts site.inspect

site = Site.new
site.name = "suseki.by"
site.regexp = "<div class=\"price\">(.*) <span>руб.</span></div>"
site.save
puts site.inspect

site = Site.new
site.name = "mirbt.by"
site.regexp = "<span class=\"secondPrice\">(.*)руб.</span>"
site.save
puts site.inspect

site = Site.new
site.name = "7sotok.by"
site.regexp = "price\">.\?.\?\n\t\t\t\t<span>(.*)руб</span>"
site.save
puts site.inspect


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

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_990_ast.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/trimmery/trimmer-mtd-990-ast"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/624"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save
################################ ITEMS  MTD 827 AST ###################
item = Item.new
item.name = "MTD 827 AST"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/7205/Trimmery-benzinovyye-/Trimmer-benzinovyy-MTD-827-AST/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/22109/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/benzinovie_trimmeri/benzotrimmeri_MTD/mtd_827_ast/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1728"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save


url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/trimmery/mtd-827-ast"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/garden-trimmers/mtd/trimmer_benzinovyy_mtd_827/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_827_ast.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save


item.save

################################ ITEMS  MTD 1033 AST ###################
item = Item.new
item.name = "MTD 1033 AST"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/7205/Trimmery-benzinovyye-/Trimmery-benzinovyye-mtd-/Trimmer-benzinovyy-MTD-710-AST/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/8865/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1831"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_1033.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 1043 AST###################
item = Item.new
item.name = "MTD 1043 AST"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Trimmery-benzinovyye/Trimmery-benzinovyye-mtd/8434/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-trimmer/6969/7007/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1832"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/trim_mtd/trim_mtd/mtd_1043.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 32 E###################
item = Item.new
item.name = "MTD 32 E"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/7205/Gazonokosilki-elektricheskiye-/Gazonokosilki-elektricheskiye-MTD-/Gazonokosilka-elektricheskaya-MTD-SMART-32-E/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/17279/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1738"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_electro_gazon/mtd_electro_gazon/89.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-32-e"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_smart_32_e/?sphrase_id=27213"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 38 E###################
item = Item.new
item.name = "MTD 38 E"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilki-elektricheskiye/Gazonokosilka-elektricheskaya-MTD-SMART-38-E/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/17280/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Elektrogazonokosilki/Elektrogazonokosilki_MTD/16872/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1739"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_electro_gazon/mtd_electro_gazon/mtd_smart_38_e.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-38-e"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_smart_38_e/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 395 PO###################
item = Item.new
item.name = "MTD 395 PO"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-395-po"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-nesamokhodnaya-MTD-395-PO/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/7010/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3941/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=80"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_395_po.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-395-po"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_benzinovaya_mtd_395_po/?sphrase_id=27211"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_benzinovaya_mtd_395_po/?sphrase_id=27211"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

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

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_po.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-46-po"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_46_po_smart/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/56"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 46 PB###################
item = Item.new
item.name = "MTD 46 PB"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/-gazonokosilka-nesamohodnaya-benzinovaya-mtd-46-pb"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-MTD-OPTIMA-46-PB/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18107/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3943/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1741"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_pb.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-46-pb"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_46_pb_optima/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/69"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 46 SPO###################
item = Item.new
item.name = "MTD 46 SPO"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spo"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPO/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/3514/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3944/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1742"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_spo.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-46-spo"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_46_spo_smart/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/92"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 46 SPB###################
item = Item.new
item.name = "MTD 46 SPB"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spb"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPB/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/20360/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3946/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1743"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_46_spb.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-46-spb"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_46_spb_optima/?sphrase_id=27216"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/70"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 46 SPB HW###################
item = Item.new
item.name = "MTD 46 SPB HW"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-46-spb-hw"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-46-SPB-HW/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6997/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3947/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1746"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/62.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-46-spb-hw"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_46_spb_hw_optima/?sphrase_id=27216"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 51 BO###################
item = Item.new
item.name = "MTD 51 BO"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-nesamohodnaya-benzinovaya-mtd-51-bo"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gaznokosilki-benzinovyye-nesamokhodnyye/Gazonokosilka-benzinovaya-nesamokhodnaya-MTD-51-BO/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6998/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3940/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=79"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_51_bo.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-51-bo"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_benzinovaya_mtd_51_bo/?sphrase_id=27221"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/57"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 53 SPO###################
item = Item.new
item.name = "MTD 53 SPO"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/benzinovaya-samohodnaya-gazonokosilka-mtd-53-spo"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-53-SPO/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6996/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3948/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1749"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spo.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-smart-53-spo"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_53_spo_smart/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/91"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 53 SPB###################
item = Item.new
item.name = "MTD 53 SPB"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-SMART-53-SPB/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/9142/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/3949/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1748"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spb.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-53-spb"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_53_spb_optima/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/71"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 53 SPB HW###################
item = Item.new
item.name = "MTD 53 SPB HW"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/benzinovaya-samohodnaya-gazonokosilka-mtd-53-spb-hw"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/7205/Gazonokosilki-benzinovyye-samokhodnyye-/Gazonokosilka-benzinovaya-samokhodnaya-MTD-53-SP-CWH/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18112/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/10114/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1747"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spb_hw.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-optima-53-spb-hw"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_53_spb_hw_optima/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 53 SPK HW###################
item = Item.new
item.name = "MTD 53 SPK HW"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/gazonokosilka-samohodnaya-benzinovaya-mtd-53-spk-hw"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-ADVANCE-53-SPK-HW/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/18108/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/14621/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_53_spk_hw.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/benzinovaya-gazonokosilka-mtd-53-spk-hw"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_53_spk_hw_advance/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD 53 SPKV HW###################
item = Item.new
item.name = "MTD 53 SPKV HW"
item.group_id = 1

url = Url.new
url.url = "http://vitrina.shop.by/GAZONOKOSILKI-I-TRIMMERY/Gazonokosilka-benzinovaya-MTD-ADVANCE-53-SPKV-HW/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/kak-vibrat-kosilku/kosilki-mtd/6995/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/mtd_advance_53_spkv_hw/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1775"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd_benzo_gazon/mtd_benzo_gazon/mtd_advance_53_spkv_hw.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/gazonokosilki/mtd-advance-53-spkv-hw"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/gazonokosilki/mtd/gazonokosilka_mtd_53_spkv_hw_advance/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD SMART RC 125###################
item = Item.new
item.name = "MTD SMART RC 125"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-rc-125"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/7205/Minitraktory/Minitraktor-MTD-SMART-RC-125/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/10878/17278/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Gazonokosilki_Trimmeri/Benzinovie_gazonokosilki/benzogazonokosilki_MTD/mtd_smart_rc_125/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1154"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_rc_125.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/mtd-smart-rc-125"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://7sotok.by/pages/product/view/101"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD OPTIMA LE 155H###################
item = Item.new
item.name = "MTD OPTIMA LE 155H"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-le-155-h"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/7205/Minitraktory/Rayder-minitraktor-MTD-OPTIMA-LE-155-H-RTG/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/10878/MTD_155_H_RTG/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1242"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_le_155_h.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/minitraktor-mtd-le-155-h"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD OPTIMA LN 200 H###################
item = Item.new
item.name = "MTD OPTIMA LN 200 H"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/mini-traktor-sadovyj-mtd-ln-200-h"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/7205/Minitraktory/Rayder-minitraktor-MTD-OPTIMA-LE-200-H-RTG/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/10878/18118/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=1243"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/sadovye_minitraktory/mtd_ln_200_h.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/minitraktory/mtd-optima-ln-200-h-rtg"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

item.save

################################ ITEMS MTD Т/205###################
item = Item.new
item.name = "MTD Т/205"
item.group_id = 1

url = Url.new
url.url = "http://50.by/products/kultivator-benzinovyj-mtd-t205"
url.site_id = Site.where("name = ?", "50.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://vitrina.shop.by/7205/Kultivatory/Kultivator-benzinovyy-MTD-T-205/"
url.site_id = Site.where("name = ?", "vitrina.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://krama.by/sadovaya-tehnika/Kak-vybrat-kultivator/kultivatory_MTD/8868/"
url.site_id = Site.where("name = ?", "krama.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://stroitel.shop.by/Dacha_Sad_Ogorod/Motobloki_traktora/Motobloki_Traktora_mtd/4401/"
url.site_id = Site.where("name = ?", "stroitel.shop.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.ydachnik.by/catalog/?id=489"
url.site_id = Site.where("name = ?", "ydachnik.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://mir-mtd.by/catalog/product/mtd/mtd/mtd_t_205.html"
url.site_id = Site.where("name = ?", "mir-mtd.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://gepard.by/sadovaya-tehnika/kultivatory/kultivator-mtd-t-205"
url.site_id = Site.where("name = ?", "gepard.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.suseki.by/catalog/kultivatory/mtd/kultivator_benzinovyy_mtd_t205/"
url.site_id = Site.where("name = ?", "suseki.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t205/"
url.site_id = Site.where("name = ?", "mirbt.by").first.id
item.urls << url
url.save

url = Url.new
url.url = "http://www.mirbt.by/vse_dlya_doma/kultivatory/mtd/mdt_t205/"
url.site_id = Site.where("name = ?", "7sotok.by").first.id
item.urls << url
url.save

item.save