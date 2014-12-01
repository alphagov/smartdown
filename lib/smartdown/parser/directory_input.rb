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
        recursive_files_relatively_renamed("snippets")
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

      def recursive_files_relatively_renamed(parent_dir, depth=nil)
        parent_path = @coversheet_path.dirname + parent_dir
        return [] unless File.exists?(parent_path)
        
        depth ||= parent_path.each_filename.count
        parent_path.each_child.flat_map do |path| 
          if path.directory?
            recursive_files_relatively_renamed(path, depth)
          else
            InputFile.new(path, relatively_name(path, depth))
          end
        end
      end

      def relatively_name(path, depth)
        path.each_filename.to_a[depth..-1].join('/')
      end

    end

    class InputFile
      def initialize(path, name=nil)
        @path = Pathname.new(path.to_s)
        @name = name ||= @path.basename
      end

      def name
        @name.to_s.split(".").first
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
