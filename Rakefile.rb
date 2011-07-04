require 'pathname'
require 'pry'

DIR = Pathname.new File.dirname(__FILE__)

include Rake::DSL

def compile path
  case path.extname
    when '.haml'
      sh "haml #{path} > #{DIR + path.basename.to_s.gsub('.haml', '.html')}"
    when '.sass'
      sh "sass #{path} > #{DIR + 'css' + path.basename.to_s.gsub('.sass', '.css')}"
  end
end





desc 'Compile all haml and sass'
task :build do
  Pathname.glob('**/*').each do |f|
    compile f if f.file?
  end
end

desc 'Watch the site and regenerate when needed'
task :watch do
  require 'fssm'
  puts "Watching for changes..."
  FSSM.monitor(DIR) do
    update do |b, r, t|
      f = Pathname.new(b) + r

      compile f if f.file?

    end
  end
end

desc 'Deploy my site'
task :deploy do
  
end

task :default => [:build, :watch]