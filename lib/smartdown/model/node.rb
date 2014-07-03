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
        elements_of_kind(Smartdown::Model::Element::MultipleChoice)
      end

      def title
        h1s.first ? h1s.first.content : ""
      end

      def markdown_blocks
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading, Hash)
      end

      def h1s
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading)
      end

      def body
        markdown_blocks[1..-1].map { |block| block.values.first }.compact.join("\n")
      end

    private
      def elements_of_kind(*kinds)
        elements.select {|e| kinds.any? {|k| e.is_a?(k)} }
      end
    end
  end
end
