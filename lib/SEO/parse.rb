require 'open-uri'
require 'active_support'

start_id = 1
#end_id = 332
end_id = 2
url_list = []
path = "E:/Rails/Tools/lib/SEO/json/"

begin
  start_id.upto(end_id) { |id|
    url = "http://www.cnal.com/news/domestic/industry/index-#{id}.html"
    html = open(url).read
    html.scan(/<ul class="item changebig">(.+?)<\/ul>/m)
    $1.scan(/<a target="_blank" href="(.+?)">/m) {
      url_list << $1.scan(/\/news\/\d{4}\/\d{4}\/.{4}-\d{5}.shtml/i)
    }
    puts url + " ok!"
    sleep(5)
  }
rescue
  #
end
url_list.each { |url|
  url2 = "http://www.cnal.com"+url.to_s if url.to_s!=""

  url2.scan(/\/\d{4}\/\d{4}\/(.+?).shtml/m)
  puts id = $1

  html2 = open(url2).read
  html2.scan(/<title>(.+?)_(.+?)_(.+?)<\/title>/m)
  puts title = $1

  html2.scan(/<h4 class="info">(.+?)<\/h4>/m)
  $1.scan(/时间：(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) &nbsp;&nbsp;来源：/m)
  puts datetime = $1

  html2.scan(/<div class="infocontent">(.+?)<\/div>/m)
  puts content = $1

  hash = { :title => "#{title}", :datetime => "#{datetime}", :content => "#{content}"}
  json = hash.to_json
  File.open("#{path}#{id}.json","w") do |file|
    file.puts json
  end

  puts url2 + " ok!"
  sleep(5)
}
