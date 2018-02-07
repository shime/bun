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
$ bun install rspec
```

Install Pry in development group:

```
$ bun install pry --development 
```

Install RSpec and Cucumber in test group:

```
$ bun install rspec cucumber --test
```

Uninstall RSpec:

```
$ bun uninstall rspec
```

Uninstall Rails:

```
$ bun rm rails
```

Install Cuba with strict version range:

```
$ bun i cuba --strict
```

Add Sequel to the Gemfile and exit without installing it:

```
$ bun i sequel --skip-install
```

Just print the gem name with the latest version found and exit:

```
$ bun i sequel --print
```

More info:

```
$ bun --help
```

## Prior art

* [Gemrat](https://github.com/drurly/gemrat)

## License

[MIT](/license)
