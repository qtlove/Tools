require 'open-uri'
require 'active_support'
########初始化##################################################################
root_dir = "E:/Rails/Tools/lib/SEO/results/"
website_name = "lxc"
channel_name = "international_enterprise_news"
url_list = []
########创建目录#################################################################
base_dir = root_dir + website_name + "/"
json_dir = base_dir + "json" + "/" + channel_name + "/"
log_dir = base_dir + "log" + "/" + channel_name + "/"
FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
FileUtils.mkdir_p json_dir unless File.directory?(json_dir)
FileUtils.mkdir_p log_dir unless File.directory?(log_dir)
########获取URL列表##############################################################
File.open("#{base_dir}#{channel_name}.list") { |f| f.read.split("\n").collect{ |url| url_list << url } }
logger = Logger.new("#{log_dir}#{Time.now.strftime("%Y-%m-%d")}.log")
url_list.each { |url|
  begin
    html = open(url).read
    html.scan(/<div class="main1">(.+?)<div class="updown">/m)
    content = $1
    unique_url = url.scan(/\/news\/\d+\/\d+\/(detail-\d+-\d+).html/m).to_s
    title = content.scan(/<h2>(.+?)<\/h2>/m).to_s
    description = content.scan(/<div class="txt">(.+?)<\/div>/m).to_s.gsub("\r\n\t", "")
    created_at = content.scan(/<span>时间：(.+?)<\/span>/m).to_s.gsub("\r\n\t", "").gsub("\t", "")
    tags = content.scan(/<span>关键字：(.+?)<\/span>/m).to_s
    hash = { :title => "#{title}", :description => "#{description}", :tags => "#{tags}", :created_at => "#{created_at}"}
    json = hash.to_json
    File.open("#{json_dir}#{unique_url}.json","w") { |file| file.puts json }
    #    logger.info("I, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]  INFO -- : "+url)
  rescue
    logger.error("E, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR -- : "+url)
  end
  sleep(3)
}
logger.info("END")
logger.close
