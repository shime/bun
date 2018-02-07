require "json"
require "open-uri"
require "tty/spinner"

class VersionFetcher
  RUBYGEMS_SEARCH_URL = "https://rubygems.org/api/v1/search.json"
  def initialize(gem, arguments)
    @gem = gem
    @arguments = arguments
  end

  def fetch_latest_version
    version = nil

    with_optional_spinner do
      response = open("#{RUBYGEMS_SEARCH_URL}?query=#{gem}").read
      json_response = JSON.parse(response)
      latest_gem_attributes = json_response.
        find {|attributes| attributes["name"] == gem }

      unless latest_gem_attributes
        raise ::Bun::Errors::GemNotFoundError.new("Aborting. Gem not found: #{gem}")
      end

      version = latest_gem_attributes["version"]
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

  attr :gem
  attr :arguments
end
