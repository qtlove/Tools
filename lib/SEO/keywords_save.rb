require 'rubygems'
require 'active_record'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  #  :host => "222.73.38.31",
  :database => "lxc360",
  :username => "root",
  :password => "123456",
  #  :username => "sunyd",
  #  :password => "sunyd{}123",
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
  def self.save_tags(article, tags)
    if tags != ""
      transaction() {
        tags.split(" ").collect{ |t|
          tag = ArticleTag.find_by_name(t)
          if tag.nil?
            tag = ArticleTag.new
            tag.name = t
            tag.save
          end
          article.tags << tag
        }
      }
    end
  end
end
class ArticleTag < ActiveRecord::Base
  has_and_belongs_to_many :articles, :class_name => "Article", :join_table => "articles_tags", :foreign_key => "tag_id"
end
class ArticlesTag < ActiveRecord::Base
end

#articles = Article.find_all_by_is_delete(false)
articles = Article.find_by_sql("SELECT * FROM articles WHERE id NOT IN (SELECT article_id FROM articles_tags)")
for a in articles
  if a.tags.size == 0
    begin
      Article.save_tags(a, get_keywords(a.title, a.description.gsub(/<\/?[^>]*>/, "")[0, 1000]))
    rescue
      puts a.id.to_s + ","
    end
  end
  sleep(1)
end
