module Smartdown
  module Model
    class Node
      attr_accessor :name, :front_matter, :body_blocks

      def initialize(name, body_blocks, front_matter = nil)
        @name = name
        @body_blocks = body_blocks
        @front_matter = front_matter || Smartdown::Model::FrontMatter.new
      end

      def questions
        body_blocks.select { |b| b.is_a?(Smartdown::Model::Question::MultipleChoice) }
      end

      def title
        h1s.first.to_s.strip
      end

      def markdown_blocks
        body_blocks.select { |b| b.is_a?(Hash) }
      end

      def h1s
        markdown_blocks.select {|b| b.has_key?(:h1) }.map { |b| b.fetch(:h1) }
      end

      def body
        markdown_blocks[1..-1].map { |block| block.values.first }.compact.join("\n")
      end
    end
  end
end
