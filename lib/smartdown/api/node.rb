module Smartdown
  module Api
    class Node

      attr_reader :title ,:elements, :front_matter, :name

      def initialize(node)
        node_elements = node.elements.clone
        headings = node_elements.select { |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        }
        nb_questions = node_elements.select{ |element|
          element.class.to_s.include?("Smartdown::Model::Element::Question")
        }.count
        if headings.count > nb_questions
          node_elements.delete(headings.first) #Remove page title
          @title = headings.first.content.to_s
        end
        @elements = node_elements
        @front_matter = node.front_matter
        @name = node.name
      end

      def body
        elements_before_smartdown = elements.take_while{|element| !smartdown_element?(element)}
        build_govspeak(elements_before_smartdown)
      end

      def post_body
        elements_after_smartdown = elements.select{ |element| !next_node_element?(element) }
                                           .reverse
                                           .take_while{|element| !smartdown_element?(element)}
                                           .reverse
        build_govspeak(elements_after_smartdown)
      end

      def next_nodes
        elements.select{ |element| next_node_element? element }
      end

      def permitted_next_nodes
        next_nodes
      end

    private

      def markdown_element?(element)
        (element.is_a? Smartdown::Model::Element::MarkdownLine) || 
        (element.is_a? Smartdown::Model::Element::MarkdownHeading) ||
        (element.is_a? Smartdown::Model::Element::MarkdownBlankLine)
      end

      def next_node_element?(element)
        (element.is_a? Smartdown::Model::NextNodeRules)
      end

      def smartdown_element?(element)
        !markdown_element?(element)
      end

      def build_govspeak(elements)
        elements.select { |element| markdown_element?(element) }
        return nil if elements.empty?
        elements.map(&:content).join("\n")
      end
    end
  end
end
