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
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading, Smartdown::Model::Element::MarkdownParagraph)
      end

      def h1s
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading)
      end

      def body
        markdown_blocks[1..-1].map { |block| as_markdown(block) }.compact.join("\n")
      end

    private
      def elements_of_kind(*kinds)
        elements.select {|e| kinds.any? {|k| e.is_a?(k)} }
      end

      def as_markdown(block)
        case block
        when Smartdown::Model::Element::MarkdownHeading
          "# #{block.content}\n"
        when Smartdown::Model::Element::MarkdownParagraph
          block.content
        else
          raise "Unknown markdown block type '#{block.class.to_s}'"
        end
      end
    end
  end
end
