class A
  def a
    def b
      print "bbb"
    end
  end
  
  def c
    b
  end
end

A.new.c