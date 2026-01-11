# Avo::Acronym::Support

Automatically fixes Zeitwerk URL inflection conflicts in Avo. Just add to your Gemfile - no configuration needed.

## The Problem

When Rails applications configure `inflect.acronym "URL"`:

```ruby
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "URL"
end
```

Zeitwerk expects `Avo::URLHelpers` for the file `avo/helpers/url_helpers.rb`, but Avo defines `Avo::UrlHelpers`. This causes:

```
Zeitwerk::NameError: expected file .../avo/helpers/url_helpers.rb to define constant URLHelpers, but defined UrlHelpers
```

## Installation

Add to your Gemfile:

```ruby
gem "avo-acronym-support"
```

Then run:

```bash
bundle install
```

**That's it.** The gem automatically fixes the URL helpers constant naming conflict when your Rails app loads.

## How It Works

This gem uses a Rails Railtie to automatically ensure both `Avo::UrlHelpers` and `Avo::URLHelpers` exist after Rails initialization. When only one form is defined, it creates an alias to the other, so Zeitwerk's autoloader works regardless of your inflection configuration.

No manual setup or code changes required - just include the gem.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/avo-acronym-support.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
