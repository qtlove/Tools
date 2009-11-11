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

redis_host = "124.74.201.132"

#yesterday = 1.day.ago
yesterday = 0.day.ago
entity_types = ["a", "p"]
entity_types.each do |entity_type|
  pattern_key = entity_type+yesterday.strftime("%y%m%d")+"-*-*-*"

  db = Redis.new({ :host => redis_host })
  for key in db.keys(pattern_key)
    db.delete("#{key}")
  end
  puts entity_type+" ok!"

end
