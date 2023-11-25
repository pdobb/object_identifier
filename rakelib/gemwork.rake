# frozen_string_literal: true

# Load additional tasks defined by Gemwork.
Gem::Specification.find_by_name("gemwork").tap do |gemspec|
  Rake.load_rakefile("#{gemspec.gem_dir}/lib/tasks/Rakefile")
end
