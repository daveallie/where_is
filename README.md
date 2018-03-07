# Where Is

Gem based on https://gist.github.com/wtaysom/1236979.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'where_is'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install where_is

## Usage

```ruby
# Where.is takes a class and an optional method

Where.is(Where, :is)
# => {:file=>"/Users/david/repos/daveallie/where_is/lib/where_is.rb", :line=>5, :path=>"/Users/david/repos/daveallie/where_is/lib/where_is.rb:5"}

Where.is(IRB)
# => {:file=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/inspector.rb", :line=>24, :path=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/inspector.rb:24"}

Where.is(String, :empty?) # This method is defined in C
# => {:file=>"String#empty?", :line=>nil, :path=>"String#empty?:"}


# Where.are takes a class and an optional method and will return all definitions
# of the method/class
Where.are(Where, :is)
# => [{:file=>"/Users/david/repos/daveallie/where_is/lib/where_is.rb", :line=>5, :path=>"/Users/david/repos/daveallie/where_is/lib/where_is.rb:5"}]

Where.are(IRB)
# => [
#   {:file=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/inspector.rb", :line=>24, :path=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/inspector.rb:24"},
#   {:file=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/workspace.rb", :line=>112, :path=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/workspace.rb:112"},
#   {:file=>"(eval)", :line=>2, :path=>"(eval):2"},
#   {:file=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb.rb", :line=>350, :path=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb.rb:350"},
#   {:file=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/init.rb", :line=>16, :path=>"/Users/david/.rvm/rubies/ruby-2.3.1/lib/ruby/2.3.0/irb/init.rb:16"}
# ]


Where.is(String, :unknown_method)
# NameError: undefined method `unknown_method' for class `#<Class:String>'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daveallie/where_is. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
