# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new do |t|
  t.fail_on_error = false
end

require "reek/rake/task"

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

task :default do
  tasks = %i[
    test
    rubocop
    reek
  ]

  tasks.each_with_index do |name, index|
    puts "== Running #{name} #{"=" * (70 - name.size)}\n"
    Rake::Task[name].invoke
    puts "== Done #{"=" * 74}"
    puts unless index.next == tasks.size
  end
end
