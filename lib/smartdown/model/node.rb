require 'smartdown/model/front_matter'

module Smartdown
  module Model
    Node = Struct.new(:name, :elements, :front_matter) do
      def initialize(name, elements, front_matter = nil)
        super(name, elements, front_matter || Smartdown::Model::FrontMatter.new)
      end

      def questions
        elements_of_kind(Smartdown::Model::Element::Question)
      end

      #Because question titles and page titles use the same markdown,
      #there are at least as many or more headings than questions on each page
      #To get only the question titles, we are assuming that all the headings that
      #are not question headings come first in the markdown, then question headings
      def question_titles
        h1s.drop(h1s.count - questions.count)
      end

      def title
        h1s.first ? h1s.first.content : ""
      end

      def body
        markdown_blocks[1..-1].map { |block| as_markdown(block) }.compact.join("\n")
      end

      private

      def markdown_blocks
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading, Smartdown::Model::Element::MarkdownParagraph)
      end

      def h1s
        elements_of_kind(Smartdown::Model::Element::MarkdownHeading)
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
