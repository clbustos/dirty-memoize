$:.unshift(File.expand_path(File.dirname(__FILE__)+"/lib"))
$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'rake'
require 'hoe'
require 'dirty-memoize'
require 'rspec'
require 'rspec/core/rake_task'


Hoe.plugin :git

h=Hoe.spec 'dirty-memoize' do
  self.testlib=:rspec
  self.rspec_options << "-c" << "-b"
  self.developer('Claudio Bustos', 'clbustos_at_gmail.com')
  self.version=DirtyMemoize::VERSION
  self.extra_dev_deps << ["rspec",">=2.0"] 
end
