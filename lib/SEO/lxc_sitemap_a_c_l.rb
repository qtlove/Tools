require "rexml/document"
require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "lxc360",
  #  :username => "root",
  #  :password => "123456",
  :username => "sunyd",
  :password => "sunyd{}123",
  :encoding => "utf8"
)
class ArticleCategory < ActiveRecord::Base
end
class Article < ActiveRecord::Base
end

out_file_name = "/home/sinasohubaidu/demo/public/sitemap-a-c-l.xml"
#out_file_name = "sitemap-a-c-l.xml"
out_doc = REXML::Document.new()
out_doc.add(REXML::XMLDecl.new(version="1.0", encoding="UTF-8"))
#xml_root
root_element = REXML::Element.new("urlset")
root_element.add_attribute("xmlns","http://www.google.com/schemas/sitemap/0.84")
out_doc.add_element(root_element)

@article_categories = ArticleCategory.find(:all, :conditions => ["parent_id = ? AND is_delete = ?", 1, 0])
for ac in @article_categories
  category_id = ac.id
  total_count = Article.count_by_sql(["SELECT COUNT(*) FROM articles WHERE category_id = ? AND is_delete = ?", category_id, 0])
  per_page = 6
  page_count = total_count/per_page + 1
  1.upto(page_count) do |i|
    loc        = "http://www.lxc360.com/article/category/#{category_id}-#{i}"
    lastmod    = "#{Time.now.strftime("%Y-%m-%d")}"
    changefreq = "weekly"
    priority   = "0.5"

    #url
    url_element = REXML::Element.new("url")
    root_element.add_element(url_element)
    #url_loc
    url_loc_element = REXML::Element.new("loc")
    url_loc_element.add_text(loc)
    url_element.add_element(url_loc_element)
    #lastmod
    url_lastmod_element = REXML::Element.new("lastmod")
    url_lastmod_element.add_text(lastmod)
    url_element.add_element(url_lastmod_element)
    #changefreq
    url_changefreq_element = REXML::Element.new("changefreq")
    url_changefreq_element.add_text(changefreq)
    url_element.add_element(url_changefreq_element)
    #priority
    url_priority_element = REXML::Element.new("priority")
    url_priority_element.add_text(priority)
    url_element.add_element(url_priority_element)
  end
end

File.open(out_file_name,"w") do |outfile|
  out_doc.write(outfile, 0)
end
