require 'rubygems'
require 'open-uri'
require "nokogiri"
require 'rubyXL'

sites = ["gepard.by", "ydachnik.by", "suseki.by", "mirbt.by", "stroitel.shop.by", "50.by", "vitrina.shop.by", "7sotok.by", "krama.by", "mir-mtd.by"]
items = ["MTD T/380 M", "MTD T/330 B", "MTD T/330 M", "MTD Т/245", "MTD Т/205", "MTD OPTIMA LN 200 H", "MTD OPTIMA LE 155H", "MTD SMART RC 125", "MTD 53 SPKV HW", "MTD 53 SPK HW",
	 "MTD 53 SPB HW", "MTD 53 SPB", "MTD 53 SPO", "MTD 51 BO", "MTD 46 SPB HW", "MTD 46 SPB", "MTD 46 SPO", "MTD 46 PB", "MTD 46 PO", "MTD 395 PO", "MTD 38 E",	 
	 "MTD 32 E", "MTD 1043 AST", "MTD 1033 AST", "MTD 827 AST", "MTD 990 AST"]

# http://yandex.by/yandsearch?text=mtd+827+ast&site=gepard.by
# http://www.google.by/search?num=10&q=mtd+827+ast+site:gepard.by
# //*[contains(concat( " ", @class, " " ), concat( " ", "r", " " ))]//a
# //*[@id="rso"]/li[1]/div/h3/a
# //*[@id="rso"]/li[1]/div/h3/a


# http://search.tut.by/?status=1&ru=1&encoding=1&page=0&how=rlv&query=mtd+827+ast+site%3Agepard.by
# http://nova.rambler.ru/search?utm_source=nhp&query=mtd+827+ast+site%3Agepard.by
# http://search.aol.com/aol/search?enabled_terms=&s_it=comsearch51&q=mtd+827+ast+site%3Agepard.by
# http://www.nigma.ru/?s=mtd+827+ast+site%3Agepard.by
# http://www.genon.ru/GetAnswer.aspx?QuestionText=mtd%20827%20ast%20site:gepard.by
url = "URL"
site_param = "SITE"
css = "CSS"

workbook = RubyXL::Parser.parse("search_engines.xlsx")
puts workbook
table = workbook[0].get_table(["URL", "SITE", "CSS"])
puts table
table.values[0].each do |hash|
	if !hash.empty?
		items.each do |item|
			sites.each do |site_name|
				#item_url_search (hash, item, site_name)
        
			end
			
		end
	end	
end
page = open ("http://tut.by")
html = Nokogiri::HTML page


def item_url_search (search_engine, item, site_name)
	url = search_engine[url] + (item + search_engine[site_param] + site_name).gsub(/[\ \/]/, '+')
	begin
		puts url
		# page = open url
		 html = Nokogiri::HTML page
		# puts html.css(search_engine[css])[0][:href][/http:.*/]
		# sleep(rand([500..1000])/100)	
	rescue Exception => e
		puts e
	end
	return
end