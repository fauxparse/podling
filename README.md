# Podling

Simple Rails skeleton for hosting a podcast using Active Storage.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'podling'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install podling
```

## Usage

### Set up Active Storage

Make sure you've set up Active Storage in your application by running

    rails active_storage:install
    rails db:migrate

Podling does *not* do this step for you.

Now is also a good time to configure your application's storage options
in `config/storage.yml`. See [Active Storage Overview](https://guides.rubyonrails.org/active_storage_overview.html)
for more on configuring Active Storage: another thing that Podling
doesn't do for you is decide how or where to store your audio files.

### Mount the Podling engine

Add the following line to your application's `routes.rb`:

    mount Podling::Engine => '/path'

...where `/path` is where you want Podling to appear on your site.
If you want Podling to be your whole application, you should use
`'/'` to show Podling at the root of your site.

## Configuration

You can customise certain aspects of Podling's behaviour:

    # Model class for episode
    Podling.episode_class = Podling::Episode

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
