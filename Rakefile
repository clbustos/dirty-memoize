require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "dirty-memoize"
    gem.summary = %Q{Memoize like object, with dirty setters}
    gem.description = %Q{Works like Memoize [http://raa.ruby-lang.org/project/memoize/http://raa.ruby-lang.org/project/memoize/], but with a global cache. Thats allows to delete all cache when you use #clean() or call one of the methods specified on #dirty_writer }
    gem.email = "clbustos@gmail.com"
    gem.homepage = "http://github.com/clbustos/dirty-memoize"
    gem.authors = ["Claudio Bustos"]
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'jeweler'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dirty-memoize #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
