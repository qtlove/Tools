require 'htmlentities'
coder = HTMLEntities.new
string = "&#38597;"
p coder.decode(string) # => "élan"