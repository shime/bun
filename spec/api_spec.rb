require "spec_helper"
require_relative "../lib/bun"

describe Bun do
  let(:gemfile) { "tmp/Gemfile" }
  let(:gemfile_lock) { "tmp/Gemfile.lock" }

  before :each do
    FileUtils.rm_rf("tmp", secure: true)
    Dir.mkdir("tmp")
  end

  def run
    Dir.chdir("tmp") do 
      yield
    end
  end

  describe ".add" do
    it "adds RSpec" do
      run { Bun.add("rspec") }

      expect(File.read(gemfile)).to include("rspec")
      expect(File.read(gemfile_lock)).to include("rspec")
    end

    it "adds specific version of RSpec" do
      run { Bun.add("rspec:3.7.0") }

      expect(File.read(gemfile)).to include(%Q{"rspec", "~> 3.7.0"})
      expect(File.read(gemfile_lock)).to include("rspec")
    end
  end

  describe ".remove" do
    it "removes RSpec" do
      run { Bun.add("rspec:3.7.0") }
      run { Bun.remove("rspec") }

      expect(File.read(gemfile)).to_not include("rspec")
    end
  end
end
