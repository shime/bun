require "spec_helper"
require_relative "../lib/bun"

describe "readme features" do
  let(:gemfile) { "tmp/Gemfile" }
  let(:gemfile_lock) { "tmp/Gemfile.lock" }

  before :each do
    FileUtils.rm_rf("tmp", secure: true)
    Dir.mkdir("tmp")
  end

  def run_command
    Dir.chdir("tmp") do 
      yield
    end
  end

  it "exits without errors when ran without arguments" do
    run_command { `bundle exec ../bin/bun` }
  end

  it "installs RSpec" do
    run_command { `bundle exec ../bin/bun install rspec` }

    expect(File.read(gemfile)).to include("rspec")
    expect(File.read(gemfile_lock)).to include("rspec")
  end

  describe "add" do
    it "installs RSpec" do
      run_command { `bundle exec ../bin/bun add rspec` }

      expect(File.read(gemfile)).to include("rspec")
      expect(File.read(gemfile_lock)).to include("rspec")
    end
  end

  it "installs Pry in development" do
    run_command { `bundle exec ../bin/bun install pry --development --skip-install` }
    expect(File.read(gemfile)).to include(%Q{group :development do\n  gem "pry", "~> 0.11.3"\nend})
  end

  it "installs RSpec and Cucumber in test group" do
    run_command { `bundle exec ../bin/bun install rspec cucumber --test --skip-install` }
    expect(File.read(gemfile)).to include(%Q{group :test do\n  gem "rspec", "~> 3.7.0"\n  gem "cucumber", "~> 3.1.0"\nend})
  end

  it "uninstalls RSpec" do
    run_command { `bundle exec ../bin/bun install rspec --skip-install` }
    run_command { `bundle exec ../bin/bun uninstall rspec --skip-install` }
    expect(File.read(gemfile)).to_not include("rspec")
  end

  it "uninstalls Rails" do
    run_command { `bundle exec ../bin/bun i rails --skip-install` }
    run_command { `bundle exec ../bin/bun rm rails --skip-install` }
    expect(File.read(gemfile)).to_not include("rails")
  end
end
