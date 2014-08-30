# Object Identifier

[![Gem Version](https://badge.fury.io/rb/object_identifier.png)](http://badge.fury.io/rb/object_identifier)

Object Identifier allows quick, easy, and uniform identification of an object by inspecting its class name and outputting any desirable attributes/methods. This is great for quickly logging, sending more descriptive notifications, or any other purpose.

For example:

```ruby
some_object.identify(:id, :name)
```

Which is the same as:

```ruby
"#{some_object.class.name}[id:#{some_object.id}, name:'#{some_object.name}']"
```


## Compatibility

* Ruby: MRI 1.9.3+
* Ruby: MRI 2+
* Rails: 3+


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'object_identifier'
```

And then execute:

```ruby
bundle
```


## Usage

### Defaults

Outputs the `id` attribute by default, if possible and if no other attributes
are given:

```ruby
some_object.identify  # => Movie[id:1]
```

Also works with methods:

```ruby
some_object.identify(:get_rating)  # => Movie[get_rating:"7/10"]
```

### Unknown Attributes/Methods

If the object doesn't respond to a specified attribute/method it is simply
ignored:

```ruby
some_object.identify(:gobble_gobble, :id)  # => Movie[id:1]
```

### Collections

Works great with collections:

```ruby
[some_object, some_other_object].identify(:id, :name)
  # => Movie[id:1, name:"Pi"], Contact[id:23, name:"Bob"]
```

Also allows limiting of results:

```ruby
[some_object, some_other_object].identify(:id, :name, limit: 1)
  # => Movie[id:1, name:"Pi"], ... (1 more)
```

### Overriding the Class Name

```ruby
some_object.identify(klass: "MyMovie")       # => MyMovie[id:1]
some_object.identify(klass: nil)             # => [id:1]
delayed_job.identify(klass: "Delayed::Job")  # => Delayed::Job[id:1]
```

### Nils and Empty Collections

```ruby
nil.identify(:id, :name)  # => [no objects]
[].identify               # => [no objects]
```


## Custom Object Identifiers

Internally, Object Identifier relies on a method named `inspect_lit` to return a "literally-inspected" string representation of all objects being identified. For example:

```ruby
:a_symbol.respond_to?(:inspect_lit) # => true
:a_symbol.inspect_lit               # => ":\"a_symbol\""
"a_string".inspect_lit              # => "\"a_string\""
BigDecimal(1.99, 3).inspect_lit     # => "<BD:1.99>"
```

Therefore, if you'd like to represent a custom object in a special way for object identification, just define the to-string conversion within the `inspect_lit` method.


```ruby
class MyVal
  def initialize(val)
    @val = val
  end

  def inspect_lit
    "<MOO:#{@val}>"
  end
end

OpenStruct.new(my_val: MyVal.new(42)).identify(:my_val)
# => "OpenStruct[my_val:<MOO:42>]"
```


## Authors

- Paul Dobbins
- Evan Sherwood
