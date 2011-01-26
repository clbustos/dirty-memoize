$:.unshift(File.expand_path(File.dirname(__FILE__)+"/../lib"))
begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    add_group "Libraries", "lib"
  end
rescue LoadError
end
require 'rspec'
require 'dirty-memoize.rb'


class String
  def deindent
    gsub /^[ \t]*/, ''
  end
end
