require 'rubygems'
require 'active_record'
require 'sanitize'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "taobao",
  :username => "root",
  :password => "123456",
  :encoding => "utf8"
)
class Question < ActiveRecord::Base
  has_and_belongs_to_many :tags, :class_name => "QuestionTag", :join_table => "questions_tags", :foreign_key => "question_id", :association_foreign_key => "tag_id"
  def self.save_tags(question, tags)
    if tags != ""
      transaction() {
        tags.split(" ").collect{ |t|
          tag = QuestionTag.find_by_name(t)
          if tag.nil?
            tag = QuestionTag.new
            tag.name = t
            tag.save
          end
          question.tags << tag
        }
      }
    end
  end
end
class QuestionTag < ActiveRecord::Base
  has_and_belongs_to_many :questions, :class_name => "Question", :join_table => "questions_tags", :foreign_key => "tag_id", :association_foreign_key => "question_id"
end
class QuestionsTag < ActiveRecord::Base
end

questions = Question.find(:all, :conditions => ["id > ? AND id <= ?", 54000, 110000], :select => "id, title, description")
for q in questions
  if q.tags.size == 0
    begin
      if q.description.nil?
        Question.save_tags(q, get_keywords(q.title, q.title))
      else
        Question.save_tags(q, get_keywords(q.title, Sanitize.clean(q.description)[0, 1000]))
      end
      puts q.id.to_s + "ok"
    rescue
      puts q.id.to_s + ","
    end
  end
  sleep(1)
end
puts 'all is ok'
