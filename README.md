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

Update your `Capfile`


    # Capfile, comment out existing deploy strategy
    # require 'capistrano/deploy'
    # add this line:
    require 'capistrano/git_deploy'

Then deploy as usual:

    cap staging deploy

### Utility methods

Overwrite currently deployment with what is in the repo. This is what is used during deployment.

    cap staging git:reset_hard

You can see what is currently deployed. This shows what git ref is currently deployed with the shortest possible unique string:

    cap staging git:rev-parse

Just pull down new code. Note, this doesn't restart servers.

    cap staging git:pull

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
