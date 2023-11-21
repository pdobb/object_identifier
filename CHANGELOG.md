### 0.7.0 - 2023-11-21
- Internal refactoring for more Object-Oriented goodness.
- Internal refactoring for less brittle tests.

#### BREAKING
- Change method signature of ObjectIdentifier FormatterClass initialization to expect `parameters` as a keyword argument.
- Add ObjectIdentifier::BaseFormatter as a superclass for Formatter objects to help define the above, plus whatever else it means to be an ObjectIdentifier Formatter.

### 0.6.0 - 2023-01-09
- Internal refactoring for more Object-Oriented goodness.

#### BREAKING
- Refactor `ObjectIdentifier::Identifier` to just `ObjectIdentifier`. This has no effect on instance method usage (e.g. `<my_object>.identify(...)`). But if any manual invocations were made (e.g. `ObjectIdentifier::Identifier.call(...)`) then they will need to be updated to `ObjectIdentifier.call(...)` (or just `ObjectIdentifier.(...)`, per your own style guide).

### 0.5.0 - 2023-01-04
- Add support for defining customer Formatters.
- Add ObjectInspector::Configuration#formatter_class setting for overriding the default Formatter. See the README for more.
- Add a benchmarking script for comparing performance of formatters. See the README for more.

### 0.4.1 - 2022-12-30
- Make compatible with Ruby 3.2 (and likely Ruby 3.0 and 3.1 as well).
- Update development dependencies.

### 0.4.0 - 2020-09-01
- [#4](https://github.com/pdobb/object_identifier/pull/4) Only show attribute names if identifying more than one attribute.
- Update development dependencies.

#### BREAKING
- Drop support for Ruby 2.3.

### 0.3.0 - 2019-06-27
- Fix identification of objects that implement `to_a`, such as Struct.

### 0.2.1 - 2019-02-24
- Add ability to identify instance vars.

### 0.1.0 - 2018-04-14
- Revamp gem.
- Update gem dependencies.
- Now returns "[no objects]" even if given a :klass option.


### 0.0.6 - 2016-02-06
- Fix: identify method now supports private & protected methods.
