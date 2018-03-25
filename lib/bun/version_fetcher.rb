require "json"
require "open-uri"
require "tty/spinner"

module Bun
  class VersionFetcher
    RUBYGEMS_GEM_URL = "https://rubygems.org/api/v1/gems"

    def initialize(gem, arguments)
      @gem = gem
      @arguments = arguments
    end

    def fetch_latest_version
      version = nil

      with_optional_spinner do
        json_response = JSON.parse(fetch)
        version = json_response["version"]
      end

      version
    end

    def with_optional_spinner
      if arguments.print?
        yield
      else
        spinner = TTY::Spinner.new("[:spinner] Finding latest gem version for \"#{gem}\"...")
        spinner.auto_spin
        yield
        spinner.stop("Done!")
      end
    end

    private

    def fetch
      open("#{RUBYGEMS_GEM_URL}/#{gem}.json").read
    rescue OpenURI::HTTPError
      raise ::Bun::Errors::GemNotFoundError.new("Aborting. Gem not found: #{gem}")
    end

    attr :gem
    attr :arguments
  end
end
