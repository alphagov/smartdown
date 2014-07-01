require 'pathname'

module Smartdown
  module Parser
    class DirectoryInput
      def initialize(coversheet_path)
        @coversheet_path = Pathname.new(coversheet_path.to_s)
      end

      def coversheet
        InputFile.new(@coversheet_path)
      end

      def questions
        read_dir("questions")
      end

      def outcomes
        read_dir("outcomes")
      end

      def scenarios
        read_dir("scenarios")
      end

    private
      def read_dir(dir)
        Dir[@coversheet_path.dirname + dir + "*.txt"].map do |filename|
          InputFile.new(filename)
        end
      end

    end

    class InputFile
      def initialize(path)
        @path = Pathname.new(path.to_s)
      end

      def name
        @path.basename.to_s.split(".").first
      end

      def read
        File.read(@path)
      end
    end
  end
end
