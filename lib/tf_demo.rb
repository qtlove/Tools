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

h = Hash.new
p "Loading..."
open("word_idfs.txt").each do |fr|
  l = fr.gsub("\n", "").split("\t")
  h["#{l[0]}"] = l[1]
end
p "OK!"

id = 2975
limit = 6

sql = "SELECT a.ID, a.TITLE, a.SUMMARY, b.CONTENT FROM HEJIA_ARTICLE a LEFT JOIN HEJIA_ARTICLE_CONTENT b ON (a.ID = b.ID) WHERE a.ID = #{id} LIMIT 1"
a = HejiaArticle.find_by_sql(sql)
at = get_keywords_by_httpcws(a[0].TITLE, httpcws_host, true).split(" ")
as = get_keywords_by_httpcws(a[0].SUMMARY, httpcws_host, true).split(" ")
ac = get_keywords_by_httpcws(a[0].CONTENT, httpcws_host, true).split(" ")
aw = at + as + ac
arr = aw - (aw & stop_words)
arr_tf = arr.uniq.map{|x| [x, arr.select{|y| y == x}.length/arr.size.to_f]}
arr_tfidf = []
arr_tf.each do |item|
  idf = h["#{iconv_gb2312(item[0])}"].to_f
  item[1] = item[1]*idf
  arr_tfidf << item
end
#p arr_tfidf
arr_tfidf = arr_tfidf.sort{|x, y| x[1] <=> y[1]}.reverse
#p arr_tfidf
a1 = []
size = arr_tfidf.size
limit = size if size < limit
0.upto(limit-1) do |i|
  a1 << arr_tfidf[i][0]
end
open('keywords.txt', 'a') { |f| f << a1.join(" ") }

#p Math.log(500)