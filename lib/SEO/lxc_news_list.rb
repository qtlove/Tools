require 'open-uri'
require 'active_support'
########初始化##################################################################
#base_url = "http://www.lvxingcai.com/news/domestic/industry/"
#base_url = "http://www.lvxingcai.com/news/domestic/enterprise/"
#base_url = "http://www.lvxingcai.com/news/international/industry/"
base_url = "http://www.lvxingcai.com/news/international/enterprise/"
root_dir = "E:/Rails/Tools/lib/SEO/results/"
website_name = "lxc"
#channel_name = "industry_news"
#channel_name = "enterprise_news"
#channel_name = "international_industry_news"
channel_name = "international_enterprise_news"
start_id = 181
end_id = 181
#end_id = 1
#url_list = []
########创建目录#################################################################
base_dir = root_dir + website_name + "/"
json_dir = base_dir + "json" + "/" + channel_name + "/"
log_dir = base_dir + "log" + "/" + channel_name + "/"
FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
FileUtils.mkdir_p json_dir unless File.directory?(json_dir)
FileUtils.mkdir_p log_dir unless File.directory?(log_dir)
########获取URL列表##############################################################
logger = Logger.new("#{log_dir}#{Time.now.strftime("%Y-%m-%d")}.log")
start_id.upto(end_id) { |id|
  begin
    url = "#{base_url}list-#{id}.html"
    html = open(url).read
    html.scan(/<ul class="mainul">(.+?)<\/ul>/m)
    $1.scan(/<li><a href="(.+?)">/m) {
      url0 = $1.scan(/\/news\/\d{4}\/\d{4}\/detail-\d{1}-\d{5}.html/i).to_s
      open("#{base_dir}#{channel_name}.list", "a") { |f| f.puts "http://www.lvxingcai.com" + url0 } if url0 != ""
    }
    #    logger.info("I, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]  INFO -- : "+url)
  rescue
    logger.error("E, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR -- : "+url)
  end
  sleep(6)
}
logger.info("END")
logger.close
