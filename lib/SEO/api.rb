require 'cgi'
require 'iconv'
require 'open-uri'
require 'rexml/document'

def iconv_utf8(str)
  begin
    str ? Iconv.iconv("gb2312", "UTF-8", str).join("") : str;
  rescue
    str;
  end
end

def get_keywords(title, content)
  keywords = ""
  keyword = ""
  title = CGI.escape(iconv_utf8(title))
  content = CGI.escape(iconv_utf8(content))
  post_url = "http://post.blog.hexun.com/ResponseClient.aspx?title=#{title}&content=#{content}&checkTag=1&method=hexun.photos.checkTag"
  begin
    xml = open(post_url,"User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10 GTB5").read
    result = REXML::Document.new(xml)
    result.root.each_element do |node|
      keyword = node.text if node.name == "keyword"
      keywords << keyword + " "
    end
    keywords = keywords.lstrip.rstrip
  rescue
    #
  end
  return keywords
end
