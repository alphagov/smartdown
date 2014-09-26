module Smartdown
  module Api
    class Question

      def initialize(elements)
        @elements = elements
      end

      def title
        elements.first.content
      end

      def body
        elements_before_smartdown = elements[1..-1].take_while{|element| !smartdown_element?(element)}
        build_govspeak(elements_before_smartdown)
      end

      #TODO: deprecate
      def hint
      end

    private

      attr_reader :elements

      def markdown_element?(element)
        (element.is_a? Smartdown::Model::Element::MarkdownParagraph) || (element.is_a? Smartdown::Model::Element::MarkdownHeading)
      end

      def smartdown_element?(element)
        !markdown_element?(element)
      end

      def build_govspeak(elements)
        markdown_elements = elements.select do |element|
          markdown_element?(element)
        end
        govspeak = markdown_elements.map(&:content).join("\n")
        GovspeakPresenter.new(govspeak).html unless govspeak.empty?
      end
    end
  end
end
