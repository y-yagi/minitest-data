# Minitest::Data

[![Build Status](https://travis-ci.org/y-yagi/minitest-data.svg?branch=master)](https://travis-ci.org/y-yagi/minitest-data)
[![Gem Version](https://badge.fury.io/rb/minitest-data.svg)](http://badge.fury.io/rb/minitest-data)

`Minitest::Data` provides Data-Driven-Test functionality to minitest/test.

You can use the `data` method. The `data` method is inspired by the [`data`](https://test-unit.github.io/test-unit/en/Test/Unit/Data/ClassMethods.html#data-instance_method) method of [test-unit](https://test-unit.github.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-data

## Usage

You can specify test data in `date` method.

```ruby
data("empty string" => [true, ""],
     "plain string" => [false, "hello"])
def test_empty(data)
  expected, target = data
  assert_equal(expected, target.empty?)
end
```

You can also specify block for the `data` method.

```ruby
  data do
    data_set = {}
    data_set["empty string"] = [true, ""]
    data_set["plain string"] = [false, "hello"]
    data_set
  end
  def test_empty(data)
    expected, target = data
    assert_equal(expected, target.empty?)
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/y-yagi/minitest-data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

