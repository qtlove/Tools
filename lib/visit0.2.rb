require 'bdb'
class Stat
  def initialize(key)
    @key=key
    @count = 0
    @values = []
  end
  def add(value)
    @count+=1
    @values << value
  end
  def key
    @key
  end
  def count
    @count
  end
  def to_s
    sprintf("%-45s %6d",key,count)
  end
end
class StatHash
  def initialize
    @stats = Hash.new
  end
  def add(key,time)
    stat = @stats[key] || (@stats[key] = Stat.new(key))
    stat.add(time)
  end
  def print()
    p values = @stats.values
    for stat in values
      puts stat.to_s
    end
  end
end

class Visit
  def initialize
    @start_time = Time.now
    init_args
    build_visits
    print_visits
  end
  def init_args
    puts @input = $*
  end
  def build_visits
    @stat_hash = StatHash.new
    @total_stat = Stat.new("All Visits")
    db = BDB::Btree.open('2009-08-11.db', nil, 'r')
    db.each { |k,v|
      @stat_hash.add("#{v.split("|")[1]}-#{v.split("|")[2]}-#{v.split("|")[3]}", 1)
      @total_stat.add(1)
    }
    db.close
    #    @stat_hash.add("392602-zhuangxiu-7134345", 1)
    #    @total_stat.add(1)
    #    @stat_hash.add("392603-zhuangxiu-7134345", 1)
    #    @total_stat.add(1)
    #    @stat_hash.add("392601-zhuangxiu-7134345", 1)
    #    @total_stat.add(1)
    #    @stat_hash.add("392602-zhuangxiu-7134345", 1)
    #    @total_stat.add(1)
  end
  def print_visits
    puts "Visit                                          Count"
    puts @total_stat.to_s
    puts "--------"
    @stat_hash.print()
  end
end

Visit.new