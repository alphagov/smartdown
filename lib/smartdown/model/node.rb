require 'smartdown/model/front_matter'

module Smartdown
  module Model
    class Node
      attr_accessor :name, :front_matter, :elements

      def initialize(name, elements, front_matter = nil)
        @name = name
        @elements = elements
        @front_matter = front_matter || Smartdown::Model::FrontMatter.new
      end

      def next_node_rules
      end

      def questions
        elements.select { |b| b.is_a?(Smartdown::Model::Question::MultipleChoice) }
      end

      def title
        h1s.first.to_s.strip
      end

      def markdown_blocks
        elements.select { |b| b.is_a?(Hash) }
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