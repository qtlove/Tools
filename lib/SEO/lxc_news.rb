require 'open-uri'
require 'rubygems'
require 'active_support'
require 'json'
require 'sanitize'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')
require File.join(dir, 'db')
########设置参数#################################################################
flag_list = [1, 1, 1]
config_list = [
  { :channel_name => "industry_news", :base_url => "http://www.lvxingcai.com/news/domestic/industry/", :start_id => 1, :end_id => 3, :category_id => 2 },
  { :channel_name => "international_industry_news", :base_url => "http://www.lvxingcai.com/news/international/industry/", :start_id => 1, :end_id => 3, :category_id => 2 },
  { :channel_name => "enterprise_news", :base_url => "http://www.lvxingcai.com/news/domestic/enterprise/", :start_id => 1, :end_id => 3, :category_id => 3 },
  { :channel_name => "international_enterprise_news", :base_url => "http://www.lvxingcai.com/news/international/enterprise/", :start_id => 1, :end_id => 3, :category_id => 3 }
]
root_dir = "E:/Rails/Tools/lib/SEO/results/"
website_name = "lxc"
base_dir = root_dir + website_name + "/"
FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
########开启日志#################################################################
log_dir = base_dir + "log" + "/"
FileUtils.mkdir_p log_dir unless File.directory?(log_dir)
logger = Logger.new("#{log_dir}#{Time.now.strftime("%Y%m%d%H%M%S")}.log")
########开始遍历#################################################################
0.upto(config_list.size-1) do |j|
  channel_name = config_list[j][:channel_name]
  base_url = config_list[j][:base_url]
  start_id = config_list[j][:start_id]
  end_id = config_list[j][:end_id]
  category_id = config_list[j][:category_id]
  json_dir = base_dir + "json" + "/" + channel_name + "/"
  FileUtils.mkdir_p json_dir unless File.directory?(json_dir)
  logger.info("CHANNEL #{channel_name}")
  ########获取终端页URL##########################################################
  if flag_list[0] == 1
    logger.info("  LIST START AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
    start_id.upto(end_id) { |id|
      begin
        url = "#{base_url}list-#{id}.html"
        html = open(url).read
        html.scan(/<ul class="mainul">(.+?)<\/ul>/m)
        $1.scan(/<li><a href="(.+?)">/m) {
          url0 = $1.scan(/\/news\/\d{4}\/\d{4}\/detail-\d{1}-\d{5}.html/i).to_s
          open("#{base_dir}#{channel_name}.list", "a") { |f| f.puts "http://www.lvxingcai.com" + url0 } if url0 != ""
        }
      rescue => exception
        logger.error("    ERROR AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
        logger.error("      URL: #{url}")
        logger.error("      DETAIL: #{exception}")
      end
      sleep(2)
    }
    logger.info("  LIST END AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
  end
  ########获取终端页内容#########################################################
  if flag_list[1] == 1
    logger.info("  DETAIL START AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
    url_list = []
    File.open("#{base_dir}#{channel_name}.list") { |f| f.read.split("\n").collect{ |url| url_list << url } }
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
      rescue => exception
        logger.error("    ERROR AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
        logger.error("      URL: #{url}")
        logger.error("      DETAIL: #{exception}")
      end
      sleep(6)
    }
    logger.info("  DETAIL END AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
  end
  ########保存数据###############################################################
  if flag_list[2] == 1
    logger.info("  SAVE START AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
    dir = Dir.new(json_dir)
    dir.each { |file|
      if file != "." and file != ".."
        begin
          File.open("#{json_dir}#{file}") { |f|
            result = JSON.parse f.read
            title = (result["title"])
            main_image_path = "/images/ps7.gif"
            description = result["description"]
            user_id = 2
            ip = 2130706433
            recommend_index = 1
            tags = get_keywords(title, Sanitize.clean(description))
            created_at = result["created_at"]
            Article.verify_active_connections!
            Article.save(title, main_image_path, description, user_id, category_id, ip, recommend_index, tags, created_at)
          }
        rescue => exception
          logger.error("    ERROR AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
          logger.error("      FILE: #{file.to_s}")
          logger.error("      DETAIL: #{exception}")
        end
      end
      sleep(2)
    }
    logger.info("  SAVE END AT #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
  end
end
########关闭日志#################################################################
logger.info("END")
logger.close
