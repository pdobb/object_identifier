# frozen_string_literal: true

require "yard"

YARD::Rake::YardocTask.new do |t|
  t.stats_options = ["--list-undoc"]
end
