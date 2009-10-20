require "rubygems"
require "redis"

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

yesterday = 1.day.ago
pattern_key_yesterday = "a"+yesterday.strftime("%y%m%d")+"-*-*-*"
pattern_key_today = "a"+Time.now.strftime("%y%m%d")+"-*-*-*"

db = Redis.new({:host=>"192.168.1.250"})
p "yesterday: "+db.keys(pattern_key_yesterday).size.to_s
p "today: "+db.keys(pattern_key_today).size.to_s
