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
    it "adds bun" do
      run { Bun.add("bun") }

      expect(File.read(gemfile)).to include("bun")
      expect(File.read(gemfile_lock)).to include("bun")
    end

    it "adds specific version of bun" do
      run { Bun.add("bun:1.1.0") }

      expect(File.read(gemfile)).to include(%Q{"bun", "~> 1.1.0"})
      expect(File.read(gemfile_lock)).to include("bun")
    end
  end

  describe ".remove" do
    it "removes bun" do
      run { Bun.add("bun:1.1.0") }
      run { Bun.remove("bun") }

      expect(File.read(gemfile)).to_not include("bun")
    end
  end
end
