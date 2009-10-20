require "watir"

def iconv_utf8(str)
  begin
    str ? Iconv.iconv("gb18030", "UTF-8", str).join("") : str;
  rescue
    str;
  end
end

def search()
  site = "http://www.baidu.com"
  keyword = "铝型材360网"
  browser = Watir::Browser.new
  browser.goto site
  browser.text_field(:name, "wd").set "#{iconv_utf8(keyword)}"
  browser.button(:id, "sb").click
  browser.close
end

count = 1
while true
  begin
    puts "============================================================" + count.to_s
    sleep(rand(120))
    ############################################################
    search()
    ############################################################
    count += 1
  rescue
    puts "error======================================================="
  end
end

