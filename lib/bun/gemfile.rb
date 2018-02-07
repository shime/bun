require "tempfile"

module Bun
  class Gemfile
    PATH = "Gemfile"

    def init
      return if File.file?(PATH)

      File.write(PATH, %Q{source "https://rubygems.org"\n\n}, mode: "w")
    end

    def add(gem, version_string, group)
      file = File.read(PATH)

      if file =~ /gem "#{gem}"/
        raise ::Bun::Errors::DuplicateGemError.new("Aborting. Gem already present in the Gemfile: #{gem}")
      end

      if file =~ /group :#{group} do/
        # appends gem to the end of the group block
        file.gsub!(%r{(group :#{group} do\n.*?)(end)}m,
                   "\\1  gem \"#{gem}\", \"#{version_string}\"\n\\2")
        File.write(PATH, file, mode: "w")
      else
        with_group(group) do
          File.write(PATH, "#{"  " if group }gem \"#{gem}\", \"#{version_string}\"\n", mode: "a")
        end
      end
    end

    def with_group(group)
      File.write(PATH, "\ngroup :#{group} do\n", mode: "a") if group
      yield
      File.write(PATH, "end\n", mode: "a") if group
    end

    def remove(gem)
      output = Tempfile.new(PATH)

      File.foreach(PATH) do |line|
        if line !~ /gem "#{gem}"/
          output.write(line)
        end
      end

      FileUtils.mv(output.path, PATH)
    end

    def verify_unique!(gem)
      if File.read(PATH) =~ /gem "#{gem}"/
        raise ::Bun::Errors::DuplicateGemError.new("Aborting. Gem already present in the Gemfile: #{gem}")
      end
    end

    private

    attr :runner
  end
end
