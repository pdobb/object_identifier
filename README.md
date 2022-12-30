# Object Identifier

[![Gem Version](https://badge.fury.io/rb/object_identifier.svg)](https://badge.fury.io/rb/object_identifier)
[![Build Status](https://travis-ci.org/pdobb/object_identifier.svg?branch=master)](https://travis-ci.org/pdobb/object_identifier)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0b737a72d16ec755c1ff/test_coverage)](https://codeclimate.com/github/pdobb/object_identifier/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/0b737a72d16ec755c1ff/maintainability)](https://codeclimate.com/github/pdobb/object_identifier/maintainability)

Object Identifier allows quick, easy, and uniform identification of an object by inspecting its class name and outputting any desirable attributes/methods. It is great for logging, sending descriptive notification messages, etc.

For example:

```ruby
some_object.identify(:id, :name)
```

Which is the same as:

```ruby
"#{some_object.class.name}[id:#{some_object.id}, name:\"#{some_object.name}\"]"
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_identifier"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_identifier


## Compatibility

Tested MRI Ruby Versions:
* 3.2.0
* 2.4.9
* 2.5.8
* 2.6.6


## Usage

### Defaults

`identify` outputs the `id` of the receiving object by default, if it exists and no other attributes/methods are specified.

```ruby
my_movie.identify                # => Movie[1]
```

`identify` doesn't output labels if only identifying a single attribute/method. It includes labels when two or more attributes/methods are being identified.

```ruby
my_movie.identify(:id)           # => Movie[1]
my_movie.identify(:rating)       # => Movie["7/10"]
my_movie.identify(:id, :rating)  # => Movie[id:1, rating:"7/10"]
```

Private methods can be identified just the same as public methods.

```ruby
my_movie.identify(:my_private_method)  # => Movie["Shh"]
```

### Unknown Attributes/Methods

If the object doesn't respond to a specified attribute/method it is simply ignored:

```ruby
my_movie.identify(:id, :rating, :other)  # => Movie[id:1, rating:"7/10"]
```

### Overriding Class Names

```ruby
my_delayed_job.identify(klass: "Delayed::Job")  # => Delayed::Job[1]
my_movie.identify(klass: nil)                   # => [1]
```

### Identifying Nil

```ruby
nil.identify(:id, :name)                 # => [no objects]
nil.identify(:id, :name, klass: "Nope")  # => [no objects]
```

### Collections

Collections of objects are each identified in turn.

```ruby
[my_movie, my_user].identify(:id, :name)
# => Movie[id:1, name:"Pi"], User[id:1, name:"Bob"]
```

The number of results that will be identified from a collection can be truncated by specifying the `limit` option.

```ruby
[my_movie, my_user].identify(:id, :name, limit: 1)
# => Movie[id:1, name:"Pi"], ... (1 more)
```


### Empty Collections

```ruby
[].identify  # => [no objects]
{}.identify  # => [no objects]
```


## Custom Object Identifiers

Internally, Object Identifier calls `inspect_lit` to return a "literally-inspected" string representation of an object. This works because Object, itself, is monkey-patched to define `inspect_lit` which just returns `inspect`. This is sufficient for most objects, but some objects will benefit from defining special output from `inspect_lit`.

Object Identifier defines `inspect_lit` on three other core objects: String, Symbol, and BigDecimal.

```ruby
"a_string".inspect_lit           # => "\"a_string\""
:a_symbol.inspect_lit            # => ":\"a_symbol\""
BigDecimal(1.99, 3).inspect_lit  # => "<BD:1.99>"
```

To identify an object in a special way, just define `inspect_lit` to return a custom String.

```ruby
class MyValueObject
  def initialize(val)
    @val = val
  end

  def inspect_lit
    "#{@val} Meters"
  end
end

my_value_object = MyValueObject.new(42)
OpenStruct.new(my_value: my_value_object).identify(:my_value)
# => "OpenStruct[my_value:42 Meters]"
```


## Supporting Gems

ObjectIdentifier works great with the [ObjectInspector](https://github.com/pdobb/object_inspector) gem.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdobb/object_identifier.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
