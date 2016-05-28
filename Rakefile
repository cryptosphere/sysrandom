require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rake/clean"

require "rake/extensiontask"
Rake::ExtensionTask.new("sysrandom") do |ext|
  ext.ext_dir = "ext/sysrandom"
end

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %w(compile spec rubocop)

CLEAN.include "**/*.o", "**/*.so", "**/*.bundle", "pkg", "tmp"
