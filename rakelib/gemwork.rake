# frozen_string_literal: true

spec = Gem::Specification.find_by_name("gemwork")

# Load additional tasks defined by Gemwork.
Dir.glob(
  Pathname.new(spec.gem_dir).
    join("lib", "tasks", "{util,rubocop,reek,test,prettier}.rake")) do |task|
  load(task)
end

# Redefine the default `rake` task.
task :default do
  run_tasks(%i[
    test
    rubocop
    reek
    prettier
  ])
end
