### 0.4.1 - 2022-12-?
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
