# frozen_string_literal: true

# See ./rakelib/ for additional tasks automatically loaded by rake.

require "bundler/gem_tasks"

task :default do
  run_tasks(%i[
    test
    rubocop
    reek
    yard
  ])
end

def run_tasks(tasks)
  tasks.each_with_index do |name, index|
    annotate_run(name) do
      Rake::Task[name].invoke
    end

    puts unless index.next == tasks.size
  end
end

def annotate_run(name)
  puts "= Running #{name} #{"=" * (71 - name.size)}\n"
  yield
  puts "= Done #{"=" * 75}"
end
