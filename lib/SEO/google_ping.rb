require 'cgi'
require 'net/http'

class GooglePing
  def self.ping(name, url, changesURL=nil)
    if changesURL.nil?
      rest_url = "http://blogsearch.google.cn/ping?name=#{CGI.escape(name)}&url=#{CGI.escape(url)}"
    else
      rest_url = "http://blogsearch.google.cn/ping?name=#{CGI.escape(name)}&url=#{CGI.escape(url)}&changesURL=#{CGI.escape(changesURL)}"
    end
    begin
      response = Net::HTTP.get_response(URI.parse(rest_url))
      return true if (response.code == "200") and (response.body == "Thanks for the ping.")
    rescue
      return false
    end
  end
end

p GooglePing.ping("baidu search", "http://www.baidu.com/")