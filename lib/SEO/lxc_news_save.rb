require 'rubygems'
require 'active_record'
require 'active_support'
require 'json'
########初始化##################################################################
root_dir = "E:/Rails/Tools/lib/SEO/results/"
website_name = "lxc"
channel_name = "international_enterprise_news"
################################################################################
ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "lxc360",
  :username => "root",
  :password => "123456",
  :encoding => "utf8"
)
class Article < ActiveRecord::Base
  belongs_to :category, :class_name => "ArticleCategory", :foreign_key => "category_id"
  belongs_to :user
  has_many :replies, :class_name => "ArticleReply"
  has_and_belongs_to_many :tags, :class_name => "ArticleTag",
    :join_table => "articles_tags",
    :foreign_key => "article_id",
    :association_foreign_key => "tag_id"
  def self.save(title, main_image_path, description, user_id, category_id, ip, recommend_index, tags, created_at)
    a = Article.find_by_title_and_is_delete(title, false)
    if a.nil?
      if tags == ""
        article = Article.new
        article.title = title
        article.main_image_path = main_image_path
        article.description = description
        article.user_id = user_id
        article.category_id = category_id
        article.ip = ip
        article.recommend_index = recommend_index
        article.created_at = created_at
        article.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        article.save
      else
        transaction() {
          article = Article.new
          article.title = title
          article.main_image_path = main_image_path
          article.description = description
          article.user_id = user_id
          article.category_id = category_id
          article.ip = ip
          article.recommend_index = recommend_index
          article.created_at = created_at
          article.updated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          article.save
          tags.split(" ").collect{ |t|
            tag = ArticleTag.find_by_name(t)
            if tag.nil?
              tag = ArticleTag.new
              tag.name = t
              tag.save
            else
              #
            end
            article.tags << tag
          }
        }
      end
    end
  end
end
class ArticleTag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :class_name => "Article", :join_table => "articles_tags", :foreign_key => "tag_id"
end
class ArticlesTag < ActiveRecord::Base
end
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
    begin
      File.open("#{json_dir}#{file}") { |f|
        result = JSON.parse f.read
        title = (result["title"])
        description = result["description"]
        created_at = result["created_at"]
        tags = result["tags"]
        tags = tags.gsub("中铝网", "铝型材360网").gsub("<span>转载请注明来源：", "").gsub("</span>", "")
        Article.save(title, main_image_path, description, user_id, category_id, ip, recommend_index, tags, created_at)
      }
      #      logger.info("I, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]  INFO -- : "+file.to_s)
    rescue
      logger.error("E, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR -- : "+file.to_s)
    end
  end
  sleep(1)
}
logger.info("END")
logger.close
