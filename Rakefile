require "bundler/setup"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new :default

task default: :spec do
  system "rubocop"
  system "inch --pedantic"
end
