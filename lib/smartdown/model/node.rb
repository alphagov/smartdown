require 'smartdown/model/front_matter'

module Smartdown
  module Model
    Node = Struct.new(:name, :elements, :front_matter) do
      def initialize(name, elements, front_matter = nil)
        all_elements = elements.map do |element|
          if element.is_a?(Smartdown::Model::Block)
            element.elements
          else
            element
          end
        end.flatten
        super(name, all_elements, front_matter || Smartdown::Model::FrontMatter.new)
      end

      def title
        h1s.first ? h1s.first.content : ""
      end

      def body
        markdown_blocks_before_question.map { |block| as_markdown(block) }.compact.join
      end

      def post_body
        markdown_blocks_after_question.map { |block| as_markdown(block) }.compact.join
      end

      def questions
        @questions ||= elements.select do |element|
          element.class.to_s.include?("Smartdown::Model::Element::Question")
        end
      end

      def next_node_rules
        @next_node_rules ||= elements.find { |e| e.is_a?(Smartdown::Model::NextNodeRules) }
      end

      def start_button
        @start_button ||= elements.find { |e| e.is_a?(Smartdown::Model::Element::StartButton) }
      end

      def is_start_page_node?
        @is_start_page_node ||= !!start_button
      end

      def is_question_node?
        @is_question_node ||= elements.any?{|element| element.is_a? Smartdown::Model::NextNodeRules}
      end

      def is_outcome_page_node?
        @is_outcome_page_node ||= !is_start_page_node? && !is_question_node?
      end

      private

      def markdown_blocks_before_question
        elements.take_while { |e|
          e.is_a?(Smartdown::Model::Element::MarkdownHeading) ||
          e.is_a?(Smartdown::Model::Element::MarkdownLine) ||
          e.is_a?(Smartdown::Model::Element::MarkdownBlankLine)
        }[1..-1]
      end

      def markdown_blocks_after_question
        elements.reverse.take_while { |e|
          e.is_a?(Smartdown::Model::Element::MarkdownHeading) ||
          e.is_a?(Smartdown::Model::Element::MarkdownLine) ||
          e.is_a?(Smartdown::Model::Element::MarkdownBlankLine)
        }.reverse
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
          "# #{block.content}"
        when Smartdown::Model::Element::MarkdownLine
          block.content
        when Smartdown::Model::Element::MarkdownBlankLine
          block.content
        else
          raise "Unknown markdown block type '#{block.class.to_s}'"
        end
      end
    end
  end
end
