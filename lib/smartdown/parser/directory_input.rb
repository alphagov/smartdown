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

      def scenario_sets
        read_dir("scenarios")
      end

      def snippets
        read_dir("snippets")
      end

      def filenames_hash
        {
          coversheet: coversheet.to_s,
          questions: questions.map(&:to_s),
          outcomes: outcomes.map(&:to_s),
          scenario_sets: scenario_sets.map(&:to_s)
        }
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

      def to_s
        @path.to_s
      end
    end
  end
end
