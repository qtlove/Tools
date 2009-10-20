require 'find'

unless ARGV.size == 1
  puts "Usage: #{$0}: <dir>"
  exit -1
end
dir = ARGV.gsub("/", "\\")

excludes = []
from_ext = ".rhtml"
to_ext = ".html.erb"
Find.find(dir) do |path|
  if FileTest.directory?(path)
    if excludes.include?(File.basename(path))
      Find.prune
    else
      next
    end
  else
    if File.extname(path) == from_ext
    	newpath = File.dirname(path)+"/"+File.basename(path, from_ext)+to_ext
      File.rename(path, newpath)
    end
  end
end