require "rubygems"
require "active_record"
require "httpcws_client"

mysql_host = "192.168.0.13"
mysql_database = "51hejia"
mysql_username = "51hejia"
mysql_password = "ruby"
httpcws_host = "192.168.0.6"

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => mysql_host,
  :database => mysql_database,
  :username => mysql_username,
  :password => mysql_password,
  :encoding => "utf8"
)
class HejiaArticle < ActiveRecord::Base
  self.table_name = "HEJIA_ARTICLE"
end
class WordIdf < ActiveRecord::Base
  def self.save(word)
    if !word.blank?
      wi = WordIdf.find_by_word(word)
      if wi.nil?
        wi2 = WordIdf.new({ :word => word })
        wi2.save
      else
        wi.increment!(:document, 1)
      end
    end
  end
end

stop_words = []
open("StopWords.dic").each do |fr|
  stop_words << iconv_utf8(fr.gsub("\n", "").gsub("\r", ""))
end
logger = Logger.new("#{Time.now.strftime("%Y-%m-%d")}.log")
min_id = HejiaArticle.minimum("ID")
#max_id = HejiaArticle.minimum("ID")
max_id = HejiaArticle.maximum("ID")
current_id = min_id - 1
while current_id < max_id
  begin
    sql = "SELECT a.ID, a.TITLE, a.SUMMARY, b.CONTENT FROM HEJIA_ARTICLE a LEFT JOIN HEJIA_ARTICLE_CONTENT b ON (a.ID = b.ID) WHERE a.ID > #{current_id} LIMIT 1"
    a = HejiaArticle.find_by_sql(sql)
    current_id = a[0].ID
    at = get_keywords_by_httpcws(a[0].TITLE, httpcws_host, true).split(" ")
    as = get_keywords_by_httpcws(a[0].SUMMARY, httpcws_host, true).split(" ")
    ac = get_keywords_by_httpcws(a[0].CONTENT, httpcws_host, true).split(" ")
    aw = at + as + ac
    arr = aw - (aw & stop_words)
    arr.uniq.each do |word|
      w = iconv_gb2312(word).lstrip.rstrip.gsub("　", "").gsub(" ", "")
      WordIdf.save(w) if !w.blank?
    end
    logger.info("I, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] INFO -- : "+a[0].ID.to_s)
  rescue
    logger.error("E, [#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR -- : "+a[0].ID.to_s)
  end
end
