# Capistrano::Git

A simpler faster deploy strategy that just uses a single deployed git repo instead of multiple releases folders and switching symlinks.

## Why?

I was annoyed by the time to do a deploy, particularly for small changes.

## Why not?

Immutable infrastucture is a good thing, and this is not that.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-git_deploy', :github => 'thermistor/capistrano-git_deploy', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-git_deploy

Update your `Capfile`

    # Capfile, comment out existing deploy strategy
    # require 'capistrano/deploy'
    # add this line:
    require 'capistrano/git_deploy'

## Usage

Deploy as usual:

    cap staging deploy

### Utility methods

Overwrite current deployment with what is in the repo. This is what is used by default during deployment:

    cap staging git:reset_hard

You can see what is currently deployed.

    cap staging git:deployed

This shows what git ref is currently deployed with the shortest possible unique string:

    cap staging git:rev-parse

Just pull down new changes. This is handy for small changes where a whole deploy would be overkill.

    cap staging git:pull

If the changes include something that might be cached by rails, restart any services that have rails loaded. These commands are not provided by this gem ...

    cap staging passenger:restart
    cap staging sidekiq:restart

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
