require "bundler"
require "paint"

module Bun
  class Runner
    def self.call(*arguments)
      new(*arguments).call
    end

    def initialize(*arguments)
      @arguments = arguments
    end

    def call
      parse_arguments 

      command = parsed_arguments.shift
      gems = parsed_arguments.take_while { |argument| argument !~ /^-|^--/}

      self.gemfile = Gemfile.new

      run_command(command, gems)
    end

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
      puts Paint[ex.message, :red, :bright]
      exit(1)
    end

    def uninstall(gems)
      gems.each do |gem|
        gemfile.remove(gem)
      end

      bundle_install
    end

    def install(gems = [])
      gemfile.init

      gems.each do |gem|
        if arguments.print? 
          version = version_string(VersionFetcher.new(gem, arguments).fetch_latest_version)
          puts "gem \"#{gem}\", \"#{version}\"" 
        else
          gemfile.verify_unique!(gem)
          gemfile.add(gem,
                      version_string(VersionFetcher.new(gem, arguments).fetch_latest_version),
                      arguments.group)
        end
      end

      bundle_install
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
      return if arguments.skip_install? || arguments.print?

      Bundler.with_clean_env do
        system("bundle install")
      end
    end

    def parse_arguments
      self.arguments = Arguments.new(arguments)
      self.parsed_arguments = arguments.parse
    end
  end
end
