# frozen_string_literal: true

# Run from the IRB console with:
#   load "script/benchmarking/formatters.rb"

require "benchmark/ips"

CUSTOM_FORMATTER_CLASSES ||= []

formatter_classes = [
  ObjectIdentifier::StringFormatter,
  *Array(CUSTOM_FORMATTER_CLASSES),
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

def ruby_version = @ruby_version ||= `ruby -v | awk '{ print $2 }'`.strip
puts("Reporting for: Ruby v#{ruby_version}\n\n")

puts("== Averaged ============================================================")
Benchmark.ips do |x|
  formatter_classes.each do |formatter_class|
    x.report(formatter_class) do
      formatter_class.new(objects[0]).call
      formatter_class.new(objects[0], parameters: parameterize(%i[id name])).call
      formatter_class.new(objects[0], parameters: parameterize(class: "CustomClass")).call
      formatter_class.new(objects[0], parameters: parameterize(%i[id name], class: "CustomClass")).call
      formatter_class.new(objects, parameters: parameterize(limit: 2)).call
      formatter_class.new(objects, parameters: parameterize(%i[id name], class: "CustomClass", limit: 2)).call
    end
  end

  x.compare!
end
puts("== Done ================================================================")
puts("\n")

puts("== Individualized ======================================================")
Benchmark.ips do |x|
  # rubocop:disable Style/CombinableLoops
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Default Attributes") do
      formatter_class.new(objects[0]).call
    end
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Custom Attributes") do
      formatter_class.new(
        objects[0],
        parameters: parameterize(%i[id name])).
        call
    end
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Custom Class") do
      formatter_class.new(
        objects[0],
        parameters: parameterize(class: "CustomClass")).
        call
    end
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Custom Attributes & Custom Class") do
      formatter_class.new(
        objects[0],
        parameters: parameterize(%i[id name], class: "CustomClass")).
        call
    end
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Limit 2") do
      formatter_class.new(
        objects,
        parameters: parameterize(limit: 2)).
        call
    end
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Custom Attributes & Custom Class & Limit 2") do
      formatter_class.new(
        objects,
        parameters: parameterize(%i[id name], class: "CustomClass", limit: 2)).
        call
    end
  end
  # rubocop:enable Style/CombinableLoops

  x.compare!
end
puts("== Done ================================================================")
puts("\n")
