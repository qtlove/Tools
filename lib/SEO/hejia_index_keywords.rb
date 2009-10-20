require 'rubygems'
require 'active_record'
require 'sanitize'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'SEO'))
require File.join(dir, 'api')

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "192.168.0.13",
  :database => "51hejia_index",
  :username => "51hejia",
  :password => "ruby",
  :encoding => "utf8"
)
class HejiaIndex < ActiveRecord::Base
  self.table_name = "hejia_indexes"
  has_and_belongs_to_many :keywords, :class_name => "HejiaIndexKeyword",
    :join_table => "hejia_indexes_keywords",
    :foreign_key => "index_id",
    :association_foreign_key => "keyword_id"
  def self.save_keywords(index, keywords)
    if keywords != ""
      transaction() {
        keywords.split(" ").collect{ |t|
          keyword = HejiaIndexKeyword.find_by_name(t)
          if keyword.nil?
            keyword = HejiaIndexKeyword.new
            keyword.name = t
            keyword.save
          end
          #          index.keywords << keyword
          HejiaIndexesKeyword.save(index.id, keyword.id, index.entity_type_id)
        }
      }
    end
  end
end
class HejiaIndexKeyword < ActiveRecord::Base
  has_and_belongs_to_many :indexes, :class_name => "HejiaIndex", :join_table => "hejia_indexes_keywords", :foreign_key => "keyword_id"
end
class HejiaIndexesKeyword < ActiveRecord::Base
  def self.save(index_id, keyword_id, entity_type_id)
    k = HejiaIndexesKeyword.new
    k.index_id = index_id
    k.keyword_id = keyword_id
    k.entity_type_id = entity_type_id
    k.save
  end
end

indexes = HejiaIndex.find(:all, :conditions => ["id >= ? AND id <= ?", 0, 100000], :select => "id, entity_type_id, title, description")
for idx in indexes
  if idx.keywords.size == 0
    begin
      HejiaIndex.save_keywords(idx, get_keywords(idx.title, Sanitize.clean(idx.description)[0, 1000]))
      puts idx.id.to_s + "ok"
    rescue
      puts idx.id.to_s + ","
    end
  end
  sleep(1)
end
puts 'all is ok'
