require 'digest/sha1'
require "rubygems"
require "redis"



db = Redis.new

1.upto(100) do
  random = Digest::SHA1.hexdigest(Time.now.to_s + rand.to_s)
  key = "a20090924-378463-jushang-2119438-#{random}"
  db["#{key}"] = 1
end

p db.keys("a2009*").size