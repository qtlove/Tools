require 'rubygems'
require 'sanitize'
require 'json'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')
require File.join(dir, 'db')
########初始化##################################################################
root_dir = "E:/Rails/Tools/lib/SEO/results/"
website_name = "lxc"
channel_name = "international_enterprise_news"
########创建目录#################################################################
base_dir = root_dir + website_name + "/"
json_dir = base_dir + "json" + "/" + channel_name + "/"
log_dir = base_dir + "log" + "/" + channel_name + "/"
FileUtils.mkdir_p base_dir unless File.directory?(base_dir)
FileUtils.mkdir_p json_dir unless File.directory?(json_dir)
FileUtils.mkdir_p log_dir unless File.directory?(log_dir)
########获取JSON列表#############################################################
main_image_path = "/images/ps7.gif"
user_id = 2
category_id = 3
ip = 2130706433
recommend_index = 1
################################################################################
dir = Dir.new(json_dir)
logger = Logger.new("#{log_dir}#{Time.now.strftime("%Y-%m-%d")}.log")
dir.each { |file|
  if file != "." and file != ".."
    #    begin
    File.open("#{json_dir}#{file}") { |f|
      result = JSON.parse f.read
      title = (result["title"])
      description = result["description"]
      created_at = result["created_at"]
#      description.gsub(/<\/?[^>]*>/, "")[0, 1000]
      p tags = get_keywords(title, Sanitize.clean(description))
      Article.save(title, main_image_path, description, user_id, category_id, ip, recommend_index, tags, created_at)
    }
    #      logger.info("I, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]  INFO -- : "+file.to_s)
    #    rescue
    #      logger.error("E, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR -- : "+file.to_s)
    #    end
  end
  sleep(1)
}
logger.info("END")
logger.close
