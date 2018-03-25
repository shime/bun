require "bundler"
require "paint"

module Bun
  class Runner
    def self.call(*arguments)
      new(*arguments).call
    end

    def initialize(*arguments)
      @arguments = arguments
      @gemfile = Gemfile.new

      parse_arguments
    end

    def call
      command = parsed_arguments.shift
      gems = parsed_arguments.take_while { |argument| argument !~ /^-|^--/}

      run_command(command, gems)
    end

    def uninstall(gems, opts: {})
      gems.each do |gem|
        gemfile.remove(gem)
      end

      bundle_install
    end
    alias :remove :uninstall

    def install(gems = [], opts: {})
      gemfile.init

      gems.each do |gem|
        name, version = extract_name_and_version_from_gem(gem)

        if print?
          version ||= VersionFetcher.new(name, arguments).fetch_latest_version
          puts "gem \"#{name}\", \"#{version_string(version)}\"" 
        else
          gemfile.verify_unique!(name)
          version ||= VersionFetcher.new(name, arguments).fetch_latest_version
          gemfile.add(name,
                      version_string(version),
                      arguments.group)
        end
      end

      bundle_install
    end
    alias :add :install

    private

    attr_accessor :arguments
    attr_accessor :parsed_arguments
    attr_accessor :gemfile

    def run_command(command, gems)
      with_exception_handling do
        install if arguments.empty?

        case command
        when /^install$|^i$|^add$/
          install(gems)
        when /^uninstall$|^rm$|^remove$|^d$/
          uninstall(gems)
        end
      end
    end

    def with_exception_handling
      yield
    rescue Errors::DuplicateGemError, Errors::GemNotFoundError => ex
      puts
      puts Paint[ex.message, :red, :bright]
      exit(1)
    end

    def version_string(version)
      if arguments.optimistic?
        ">= #{version}"
      elsif arguments.strict?
        "#{version}"
      else
        "~> #{version}"
      end
    end

    def bundle_install
      return if arguments.skip_install? || print?

      Bundler.with_clean_env do
        system("bundle install")
      end
    end

    def print?
      arguments.print?
    end

    def parse_arguments
      self.arguments = Arguments.new(arguments)
      self.parsed_arguments = arguments.parse
    end

    def extract_name_and_version_from_gem(gem)
      return gem unless gem =~ /:/

      gem.split(":")
    end
  end
end
