require "rubygems"
require "redis"
require "active_record"
require "active_support"

class Fixnum
  def second
    self
  end
  alias :seconds :second
  def minute
    60.seconds*self
  end
  alias :minutes :minute
  def hour
    60.minutes*self
  end
  alias :hours :hour
  def day
    24.hours*self
  end
  alias :days :day
  def week
    7.days*self
  end
  alias :weeks :week
  def ago
    Time.now - self
  end
end

mysql_host = "192.168.0.13"
mysql_database = "51hejia_index"
mysql_username = "51hejia"
mysql_password = "ruby"
redis_host = "124.74.201.132"

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => mysql_host,
  :database => mysql_database,
  :username => mysql_username,
  :password => mysql_password,
  :encoding => "utf8"
)
class HejiaPageView < ActiveRecord::Base
end


yesterday = 1.day.ago
pattern_key = "a"+yesterday.strftime("%y%m%d")+"-*-*-*"
entity_type_id = 1
view_date = yesterday.strftime("%Y%m%d")

db = Redis.new({ :host => redis_host })
HejiaPageView.transaction do
  for key in db.keys(pattern_key)
    entity_id = key.split("-")[1].to_i
    channel_name = key.split("-")[2]
    editor_id = key.split("-")[3].to_i
    view_count = db["#{key}"].to_i
    hpv = HejiaPageView.new({ :entity_type_id => entity_type_id, :entity_id => entity_id,
        :channel_name => channel_name, :editor_id => editor_id, :view_count => view_count,
        :view_date => view_date })
    hpv.save
  end
  puts "ok!"
end

