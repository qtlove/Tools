def value(i, j)
  if(j==0 || i==j+1)
    return 1;
  else
    value = value(i-1, j-1) + value(i-1, j);
    return value;
  end
end

def result(row)
  a = []
  0.upto(row-1) do |i|
    a << value(row, i)
  end
  return a
end

if ARGV.size == 1
  row = ARGV[0].to_i + 1
  if row < 1
    p 'please input valid row'
  else
    p result(row)
  end
else
  p 'usage: ruby triangle.rb [row]'
end