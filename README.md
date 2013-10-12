# Capistrano::Git

This uses just git to deploy and doens't have a releases directory.
Deploys are super fast and super simple.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-git

## Usage

    # Capfile

    require 'capistrano/git'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
