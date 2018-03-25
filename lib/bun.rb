require_relative "bun/errors"
require_relative "bun/messages"
require_relative "bun/runner"
require_relative "bun/version"
require_relative "bun/arguments"
require_relative "bun/gemfile"
require_relative "bun/version_fetcher"

module Bun
  extend self

  def add(gems, opts = {})
    runner.add(Array(gems), opts)
  end

  def remove(gems, opts = {})
    runner.remove(Array(gems), opts)
  end

  private

  def runner
    @runner ||= Runner.new
  end
end
