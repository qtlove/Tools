require 'rubygems'
require 'RMagick'

path = "E:/Rails/Tools/lib/RMagick"
cols = 200
rows = 150

dir = Dir.new(path)
image_list = Array.new
dir.each { |entry| image_list << entry if Regexp.compile(/^.+\.+(jpg|bmp|gif|png|jpeg)$/i).match(entry)}
puts "start"
image_list.each { |image|
  image.scan(/(.*)+\.+(jpg|bmp|gif|png|jpeg)$/i)
  filename = $1
  extname = "."+$2
  #  begin
  img = Magick::Image.read(image).first
  thumb = img.resize_to_fit(cols, rows)
  thumb.write "#{filename}_#{cols}x#{rows}#{extname}"
  #    puts "success!"
  #  rescue
  #    puts "failed!"
  #  end
}
puts "finished!"
exit