require 'bdb'

db = BDB::Hash.create('random_thoughts2.db', nil, BDB::CREATE)
key = rand(10000000)
db[key] = key.to_s+"中文"
db.close

db = BDB::Hash.open('random_thoughts2.db', nil, 'r')
#p db['test']
p db.size
db.each { |k,v| puts v }
# => "it never rains but it pours."
db.close
