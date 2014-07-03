require 'smartdown/model/front_matter'

module Smartdown
  module Model
    Node = Struct.new(:name, :elements, :front_matter) do
      def initialize(name, elements, front_matter = nil)
        super(name, elements, front_matter || Smartdown::Model::FrontMatter.new)
      end

      def next_node_rules
      end

      def questions
        elements.select { |b| b.is_a?(Smartdown::Model::Element::MultipleChoice) }
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
