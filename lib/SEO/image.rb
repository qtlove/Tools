require 'rubygems'
require 'RMagick'
require 'open-uri'
require 'digest/sha1'

def thumb_no_bigger_than(img, width, height)
  img.change_geometry("#{width}x#{height}") do |cols, rows, img|
    img.resize(cols, rows)
  end
end

source_url = "http://1834.img.pp.sohu.com.cn/images/blog/2009/6/19/9/5/122a2a0111bg213.jpg"
data = open(source_url).read
filename = Digest::SHA1.hexdigest(Time.now.to_s+rand(1000).to_s)
target_filename = filename + File.extname(source_url)
open(target_filename,"wb") do |f| f.write(data)
end

img = Magick::Image.read(target_filename).first
thumb_middle = thumb_no_bigger_than(img, 200, 200)
thumb_middle.write(filename+"_middle"+File.extname(target_filename))
thumb_small = thumb_no_bigger_than(img, 100, 100)
thumb_small.write(filename+"_small"+File.extname(target_filename))
