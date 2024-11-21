# frozen_string_literal: true

# Play from the IRB console with:
#   load "script/benchmarking/formatters.rb"

require "benchmark/ips"

custom_formatter_klasses ||= []

formatter_klasses = [
  ObjectIdentifier::StringFormatter,
  *Array(custom_formatter_klasses),
].freeze

MyObject = Struct.new(:id, :name)

objects = [
  MyObject.new({id: 1, name: "NAME1"}),
  MyObject.new({id: 2, name: "NAME2"}),
  MyObject.new({id: 3, name: "NAME3"}),
].freeze

def parameterize(attributes = [], **formatter_options)
  ObjectIdentifier::Parameters.build(
    attributes: attributes,
    formatter_options: formatter_options)
end

puts "== Averaged ===================================================================="
Benchmark.ips do |x|
  formatter_klasses.each do |formatter_klass|
    x.report(formatter_klass) do
      formatter_klass.new(objects[0]).call
      formatter_klass.new(objects[0], parameters: parameterize(%i[id name])).call
      formatter_klass.new(objects[0], parameters: parameterize(klass: "CustomClass")).call
      formatter_klass.new(objects[0], parameters: parameterize(%i[id name], klass: "CustomClass")).call
      formatter_klass.new(objects, parameters: parameterize(limit: 2)).call
      formatter_klass.new(objects, parameters: parameterize(%i[id name], klass: "CustomClass", limit: 2)).call
    end
  end

  x.compare!
end
puts(
  "== Done ========================================================================",
  "\n")

puts "== Individualized =============================================================="
Benchmark.ips do |x|
  # rubocop:disable Style/CombinableLoops
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Default Attributes") do
      formatter_klass.new(objects[0]).call
    end
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes") do
      formatter_klass.new(
        objects[0],
        parameters: parameterize(%i[id name])).
        call
    end
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Class") do
      formatter_klass.new(
        objects[0],
        parameters: parameterize(klass: "CustomClass")).
        call
    end
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes & Custom Class") do
      formatter_klass.new(
        objects[0],
        parameters: parameterize(%i[id name], klass: "CustomClass")).
        call
    end
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Limit 2") do
      formatter_klass.new(
        objects,
        parameters: parameterize(limit: 2)).
        call
    end
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Custom Attributes & Custom Class & Limit 2") do
      formatter_klass.new(
        objects,
        parameters: parameterize(%i[id name], klass: "CustomClass", limit: 2)).
        call
    end
  end
  # rubocop:enable Style/CombinableLoops

  x.compare!
end
puts(
  "== Done ========================================================================",
  "\n")
