module Bun
  module Messages
    USAGE = <<-USAGE.gsub /^( +)(\w+|  -)/, '\2'

    Bun

    Bundler's little helper. A missing CLI tool to install and remove gems from Gemfile with ease.

    Usage: bun <COMMAND> [GEMS] [OPTIONS] 

    Commands: 

      install    - adds gems to Gemfile, alias: i
      uninstall  - removes gems from Gemfile, alias: rm, d

    Example:

      bun install rspec --test

    Options:

    USAGE
  end
end
