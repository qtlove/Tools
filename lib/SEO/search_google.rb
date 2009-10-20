require 'rubygems'
require 'mechanize'

agents = ['Windows IE 6', 'Windows IE 7', 'Windows Mozilla', 'Mac Safari', 'Mac FireFox', 'Mac Mozilla', 'Linux Mozilla', 'Linux Konqueror', 'iPhone', 'Mechanize']
count = 1
while true
  begin
    puts "============================================================" + count.to_s
    sleep(6)
    ############################################################
    a = WWW::Mechanize.new { |agent|
      agent.user_agent_alias = agents[rand(10)]
    }
    a.get('http://www.google.cn/') do |page|
      page.form_with(:name => 'f') do |search|
        search.q = '铝型材360网'
      end.submit
    end
    ############################################################
    count += 1
  rescue
    puts "error======================================================="
  end
end
