require 'bdb'

#db = BDB::Btree.create('element_reviews.db', nil, BDB::CREATE)
#db['earth'] = 'My personal favorite element.'
#db['water'] = 'An oldie but a goodie.'
#db['fire'] = 'Perhaps the most overrated element.'
#db[rand(10000)] = 'Perhaps the most overrated element.'

db = BDB::Btree.open('2009-08-10.db', nil, 'r')
#db.each { |k,v| puts k }
puts db.size
db.close
