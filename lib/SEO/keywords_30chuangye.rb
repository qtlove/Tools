require 'rubygems'
require 'active_record'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  #  :host => "localhost",
  :host => "125.91.15.133",
  :database => "a1017143703",
  #  :username => "root",
  #  :password => "123456",
  :username => "root",
  :password => "chrdw,hdhxt.",
  :encoding => "utf8"
)
class CyaskQue < ActiveRecord::Base
  self.primary_key = "qid"
  has_and_belongs_to_many :tags, :class_name => "CyaskQueTag",
    :join_table => "cyask_ques_tags",
    :foreign_key => "cyask_que_id",
    :association_foreign_key => "cyask_que_tag_id"
  def self.save_tags(question, tags)
    if tags != ""
      transaction() {
        tags.split(" ").collect{ |t|
          tag = CyaskQueTag.find_by_name(t)
          if tag.nil?
            tag = CyaskQueTag.new
            tag.name = t
            tag.save
          end
          question.tags << tag
        }
      }
    end
  end
end
class CyaskQueTag < ActiveRecord::Base
  has_and_belongs_to_many :questions, :class_name => "CyaskQue",
    :join_table => "cyask_ques_tags",
    :foreign_key => "cyask_que_tag_id",
    :association_foreign_key => "cyask_que_id"
end
class CyaskQuesTag < ActiveRecord::Base
end

questions = CyaskQue.find_by_sql("SELECT qid, title, content FROM cyask_ques")
for q in questions
  if q.tags.size == 0
    begin
      CyaskQue.save_tags(q, get_keywords(q.title, q.content.gsub(/<\/?[^>]*>/, "")[0, 1000]))
    rescue
      puts q.id.to_s + ","
    end
  end
  sleep(3)
end
