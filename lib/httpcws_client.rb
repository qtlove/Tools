require "cgi"
require "iconv"
require "net/http"
require "sanitize"

def iconv_utf8(str)
  begin
    str ? Iconv.iconv("GB18030", "UTF-8", str).join("") : str;
  rescue
    str;
  end
end

def iconv_gb2312(str)
  begin
    str ? Iconv.iconv("UTF-8", "GB18030", str).join("") : str;
  rescue
    str;
  end
end

def get_keywords_by_httpcws(original_keywords, httpcws_host, html_tag=false, httpcws_port=1985)
  keywords = ""
  begin
    path = "/"
    original_keywords = Sanitize.clean(original_keywords) if html_tag
    data = CGI.escape(iconv_utf8(original_keywords))
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10 GTB5"
    }
    http = Net::HTTP.new(httpcws_host, httpcws_port)
    response = http.post(path, data, headers)
    keywords = response.body
  rescue
    #
  end
  return keywords
end


#original_keywords = "<a>对UTF-8编码的字符串进行中文分词处理（HTTP POST方式）"
#httpcws_host = "192.168.0.6"
##httpcws_port = 1985
#p get_keywords_by_httpcws(original_keywords, httpcws_host)
#p get_keywords_by_httpcws(original_keywords, httpcws_host, true)
