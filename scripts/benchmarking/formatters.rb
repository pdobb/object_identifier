# frozen_string_literal: true

# Play from the pry console with:
#   play scripts/benchmarking/formatters.rb

require "benchmark/ips"

custom_formatter_klasses ||= []

formatter_klasses = [
  ObjectIdentifier::StringFormatter,
  *Array(custom_formatter_klasses)
].freeze

MyObject ||= Struct.new(:id, :name)

objects = [
  MyObject.new(id: 1, name: "NAME1"),
  MyObject.new(id: 2, name: "NAME2"),
  MyObject.new(id: 3, name: "NAME3")
].freeze

puts "== Averaged ============================================================="
Benchmark.ips { |x|
  formatter_klasses.each do |formatter_klass|
    x.report(formatter_klass) {
      formatter_klass.new(objects[0]).call
      formatter_klass.new(objects[0], %i[id name]).call
      formatter_klass.new(objects[0], klass: "CustomClass").call
      formatter_klass.new(objects[0], %i[id name], klass: "CustomClass").call
      formatter_klass.new(objects, limit: 2).call
      formatter_klass.new(objects, %i[id name], klass: "CustomClass", limit: 2).call
    }
  end

  x.compare!
}
puts "== Done"

puts "== Individualized ======================================================="
Benchmark.ips { |x|
  # rubocop:disable Style/CombinableLoops
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Default Attributes") {
      formatter_klass.new(objects[0]).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes") {
      formatter_klass.new(objects[0], %i[id name]).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Class") {
      formatter_klass.new(objects[0], klass: "CustomClass").call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes & Custom Class") {
      formatter_klass.new(objects[0], %i[id name], klass: "CustomClass").call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Limit 2") {
      formatter_klass.new(objects, limit: 2).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes & Custom Class & Limit 2") {
      formatter_klass.new(objects, %i[id name], klass: "CustomClass", limit: 2).call
    }
  end
  # rubocop:enable Style/CombinableLoops

  x.compare!
}
puts "== Done"
