require "capistrano/framework"

load File.expand_path("../tasks/git.rake", __FILE__)
load File.expand_path("../tasks/deploy.rake", __FILE__)
