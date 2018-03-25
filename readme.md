# Bun

Bundler's little helper. A missing CLI tool to install and remove gems from Gemfile with ease.


![](https://twobucks.co/assets/bun-example-min.gif)

## Installation

```
$ gem install bun
```

## Usage

Install RSpec:

```
$ bun add rspec
```

Install specific version of RSpec

```
$ bun add rspec:3.7.0
```

Install Pry in development group:

```
$ bun add pry --development 
```

Install RSpec and Cucumber in test group:

```
$ bun add rspec cucumber --test
```

Uninstall RSpec:

```
$ bun remove rspec
```

Uninstall Rails:

```
$ bun remove rails
```

Install Cuba with strict version range:

```
$ bun add cuba --strict
```

Add Sequel to the Gemfile and exit without installing it:

```
$ bun add sequel --skip-install
```

Just print the gem name with the latest version found and exit:

```
$ bun add sequel --print
```

More info:

```
$ bun --help
```

# API

```ruby
require "bun"

Bun.add("rspec:3.7.0") # adds RSpec to Gemfile and runs bundle install
Bun.remove("rspec")    # removes RSpec from Gemfile
```

## Prior art

* [Gemrat](https://github.com/drurly/gemrat)

## License

[MIT](/license)
