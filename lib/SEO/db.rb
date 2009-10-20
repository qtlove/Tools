require 'rubygems'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  #  :host => "localhost",
  :host => "222.73.38.31",
  :database => "lxc360",
  #  :username => "root",
  #  :password => "123456",
  :username => "sunyd",
  :password => "sunyd{}123",
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
    a = Article.find_by_title(title)
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