require 'rubygems'
require 'httparty'

class Ebay
  include HTTParty
end

begin
  item = Ebay.get('http://rorbuilder.info/cgi-bin/ebay.cgi?q=260288310590')['ebay']
  item.each do |key, value|
    puts key + ': ' + value
  end
rescue
  p 'oops that product doesn\'t exist'
end

