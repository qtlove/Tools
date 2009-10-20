require "watir"
require 'rubygems'
require 'active_record'
require 'active_support'
ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "222.73.37.221",
  :database => "51hejia",
  :username => "hejiasql",
  :password => "sql2009",
  :encoding => "utf8"
)
class Target < ActiveRecord::Base
  self.table_name = "publish_columns"
end
columns = Target.find_by_sql("select id from publish_columns where id>52040")
for column in columns
  puts column.id
  target_page = "http://api.51hejia.com/admin/create_xml?id=#{column.id}"
  browser = Watir::Browser.new
  browser.goto target_page
  browser.close
end
