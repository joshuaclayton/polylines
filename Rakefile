require "rake"
require "rake/tasklib"
require 'bundler'
Bundler::GemHelper.install_tasks

Bundler.require

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:rspec)

task :default => [:rspec]
