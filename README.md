# Capistrano::Git

A simpler faster deploy strategy that just uses a single deployed git repo instead of multiple releases. It takes advantage of the Capistrano 3.0's new design.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-git_deploy', :github => 'thermistor/capistrano-git_deploy', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-git_deploy

## Usage

    # Capfile

    require 'capistrano/git_deploy'

## TODO

* as per [this post](http://blog.codeclimate.com/blog/2013/10/02/high-speed-rails-deploys-with-git/)
    * assets:precompile:if_changed, only precompile assets if something changed
    * bundle:install:if_changed, similar for bundler
    * deploy:verify

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
