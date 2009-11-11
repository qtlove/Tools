sk = "新闻 行业 资讯,http://www.51hejia.com/xinwen/;" +
  "卖场,http://www.51hejia.com/maichang/;" +
  "博客,http://blog.51hejia.com/;"
hk = {}
a1 = sk.split(";")
0.upto(a1.size-1) do |i|
  a2 = a1[i].split(",")[0].split(" ")
  0.upto(a2.size-1) do |j|
    k = a2[j]
    v = a1[i].split(",")[1]
    hk[k] = v
  end
end
p hk["新闻"]
p hk["新闻1"]

#open("deco_keywords_091015.txt").each do |fr|
#  #  x = fr.gsub("\n", "")
#  p fr = "\n" + fr + "x:1"
#  open('output', 'a') { |f| f << fr }
#
#end

#a = Hash.new
#open("word_idfs.txt").each do |fr|
#  #  x = fr.gsub("\n", "")
#  l = fr.gsub("\n", "").split("\t")
#  a["#{l[0]}"] = l[1]
#  #  p fr = fr.gsub("\n", "") + " => " + fr.gsub("\n", "") + "\n"
#  #  open('exceptions.txt', 'a') { |f| f << fr }
#end
#p a["组图"].to_f

#open("output2").each do |fr|
#  #  x = fr.gsub("\n", "")
##  p fr = fr.gsub("\n", "") + "  1"+ "\n"
#  fr = fr + "x:1" + "\n"
#  open('output3', 'a') { |f| f << fr }
#
#end