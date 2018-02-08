require "optparse"

module Bun
  class Arguments
    def initialize(arguments)
      @arguments = arguments
    end

    attr_accessor :optimistic, :strict, :group, :skip_install, :print

    alias :strict? :strict
    alias :optimistic? :optimistic
    alias :skip_install? :skip_install
    alias :print? :print

    def empty?
      @arguments.empty?
    end

    def parse
      opt_parser = OptionParser.new do |opts|
        opts.banner = Bun::Messages::USAGE

        opts.on("-P", "--print", "# Just print the gem name and version and exit.") do
          self.print = true
        end

        opts.on("-o", "--optimistic", "# Use optimistic version range >= instead of ~>.") do
          self.optimistic = true
        end

        opts.on("-S", "--strict", "# Use strict version instead of ~> range.") do
          self.strict = true
        end

        opts.on("-d", "--development", "# Add gem to development group.") do
          self.group = :development
        end

        opts.on("-t", "--test", "# Add gem to test group.") do
          self.group = :test
        end

        opts.on("-s", "--skip-install", "# Skip the install step.") do
          self.skip_install = true
        end

        opts.on_tail("-h", "--help", "# Print these usage instructions.") do
          puts opts
        end

        opts.on("-v", "--version", "# Show current Bun version.") do
          puts Bun::VERSION
        end
      end

      begin
        opt_parser.parse(arguments)
      rescue OptionParser::InvalidOption
        puts opt_parser
      end
    end

    private

    attr :arguments
  end
end
