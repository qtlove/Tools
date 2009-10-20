#http://github.com/rgrove/sanitize/blob/00ed7c128e23a205342bc8fd519749189a1e93a7/README.rdoc
require 'rubygems'
require 'sanitize'

html = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg" />'

p Sanitize.clean(html) # => 'foo'
