require 'rubygems'
require 'open-uri'
require "nokogiri"
require 'rubyXL'

sites = ["gepard.by", "ydachnik.by", "suseki.by", "mirbt.by", "stroitel.shop.by", "50.by", "vitrina.shop.by", "7sotok.by", "krama.by", "mir-mtd.by"]
items = ["MTD T/380 M", "MTD T/330 B", "MTD T/330 M", "MTD T/245", "MTD T/205", "MTD OPTIMA LN 200 H", "MTD OPTIMA LE 155H", "MTD SMART RC 125", "MTD 53 SPKV HW", "MTD 53 SPK HW",
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
url_column = "URL"
site_param = "SITE"
css = "CSS"
file_name = "/Users/Mikhail/RubymineProjects/distibutor/config/search/search_engines.xlsx"
clients = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73",
            ""]

workbook = RubyXL::Parser.parse(file_name)
table = workbook[0].get_table([url_column, site_param, css])
  
#sites = Site.all
#items = Item.all

  sites.each do |site|
    items.each do |item|    
      #create search query
      current_engine = rand(2..table.values[0].size)-2

      search_query = (table.values[0][current_engine][url_column] + (item + table.values[0][current_engine][site_param] + site).gsub(/[\ \/]/, '+')).gsub("&amp;",'&')
      #find url for item
      #item_url
      begin
      uri = URI.parse(search_query)
      puts uri
      #page = open(uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Cache-Control" => "max-age=0")
      #html = Nokogiri::HTML page
      #item_url = html.at_css(table.values[0][current_engine][css])[:href][/http:\/\/.*/]
      #item_url = "http://ydachnik.by"
      sleep_time = rand(10..500)/100
      #sleep_time = 0.001
      sleep(sleep_time)
      rescue Exception => e
        puts e
      end
      

      #create url, save url and item
      #url = Url.new
      #url.url = item_url
      #url.site = site
      #item.urls << url
      #url.save
      #item.save
      
      
      
  end  
end