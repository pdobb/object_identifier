# frozen_string_literal: true

require "rubocop/rake_task"

RuboCop::RakeTask.new do |t|
  t.fail_on_error = false
end
