# Object Identifier

Object Identifier allows quick, easy, and uniform identification of an object
by inspecting its class name and any desirable attributes/methods. This is great
for logging, notifications or any other purpose.

For example, instead of typing out string interpolations such as
`"#{some_object.class.name}[id:#{some_object.id}, name:'#{some_object.name}']"`
all over the place in controllers or in rescue blocks in models, etc., you can
now just use `"#{some_object.identify(:id, :name)}"`.


### Compatibility

Tested with:

* Ruby: MRI 2.0.0
* Rails: 4.0.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_identifier"
```

And then execute:

```ruby
bundle
```

## Usage

<b>Defaults</b>

Outputs the <tt>id</tt> attribute by default, if possible and if no other
attributes are given:

```ruby
some_object.identify  # => Movie[id:1]
```

Also works with methods:

```ruby
some_object.identify(:get_rating)  # => Movie[get_rating:"7/10"]
```

<b>Unknown Attributes/Methods</b>

If the object doesn't respond to a specified attribute/method it is simply
ignored:

```ruby
some_object.identify(:gobble_gobble, :id)  # => Movie[id:1]
```

<b>Collections</b>

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

<b>Overriding the Class Name</b>

```ruby
some_object.identify(klass: "MyMovie")       # => MyMovie[id:1]
some_object.identify(klass: nil)             # => [id:1]
delayed_job.identify(klass: "Delayed::Job")  # => Delayed::Job[id:1]
```

<b>Nils and Empty Collections</b>

```ruby
nil.identify(:id, :name)  # => [no objects]
[].identify               # => [no objects]
```

## Authors

- Paul Dobbins
- Evan Sherwood
