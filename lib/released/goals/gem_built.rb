module Released
  module Goals
    class GemBuilt < Released::Goal
      identifier :gem_built

      def initialize(config = {})
        @name = config.fetch('name')
        @version = config.fetch('version')
      end

      def to_s
        "gem built (#{@name})"
      end

      def try_achieve
        stdout = ''
        stderr = ''
        piper = Released::Piper.new(stdout: stdout, stderr: stderr)

        begin
          gemspec_file_path = "#{@name}.gemspec"
          piper.run(['gem', 'build', gemspec_file_path], [])
        rescue
          raise "Failed to build gem: #{stderr}"
        end
      end

      def achieved?
        File.file?(expected_name)
      end

      def failure_reason
        "file #{expected_name} does not exist"
      end

      private

      def expected_name
        @_expected_name ||= @name + '-' + @version + '.gem'
      end
    end
  end
end
