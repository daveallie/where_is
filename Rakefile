require 'bundler/gem_tasks'
require 'rubocop/rake_task'

task :default => :rubocop

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end
