#open("deco_keywords_091015.txt").each do |fr|
#  #  x = fr.gsub("\n", "")
#  p fr = "\n" + fr + "x:1"
#  open('output', 'a') { |f| f << fr }
#
#end

a = Hash.new
open("word_idfs.txt").each do |fr|
  #  x = fr.gsub("\n", "")
  l = fr.gsub("\n", "").split("\t")
  a["#{l[0]}"] = l[1]
  #  p fr = fr.gsub("\n", "") + " => " + fr.gsub("\n", "") + "\n"
  #  open('exceptions.txt', 'a') { |f| f << fr }
end
p a["组图"].to_f

#open("output2").each do |fr|
#  #  x = fr.gsub("\n", "")
##  p fr = fr.gsub("\n", "") + "  1"+ "\n"
#  fr = fr + "x:1" + "\n"
#  open('output3', 'a') { |f| f << fr }
#
#end