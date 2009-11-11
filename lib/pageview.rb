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

#yesterday = 1.day.ago
yesterday = 0.day.ago
entity_types = ["a", "p"]
entity_types.each do |entity_type|
  pattern_key = entity_type+yesterday.strftime("%y%m%d")+"-*-*-*"
  view_date = yesterday.strftime("%Y%m%d")

  db = Redis.new({ :host => redis_host })
  HejiaPageView.transaction do
    for key in db.keys(pattern_key)
      ip = key.split("-")[1].to_i
      entity_id = key.split("-")[2].to_i
      user_id = key.split("-")[3].to_i
      view_count = db["#{key}"].to_i
      hpv = HejiaPageView.new({ :ip => ip, :entity_type => entity_type, :entity_id => entity_id,
          :user_id => user_id, :view_count => view_count, :view_date => view_date })
      hpv.save
    end
    puts entity_type+" ok!"
  end
end
