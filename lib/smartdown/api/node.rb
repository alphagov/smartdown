module Smartdown
  module Api
    class Node

      attr_reader :title ,:elements, :front_matter, :name

      def initialize(node)
        node_elements = node.elements.clone
        headings = node_elements.select { |element|
          element.is_a? Smartdown::Model::Element::MarkdownHeading
        }
        @title = headings.first.content.to_s if headings.first
        nb_questions = node_elements.select{ |element|
          element.is_a? Smartdown::Model::Element::MultipleChoice
        }.count
        if headings.count > nb_questions
          node_elements.delete(headings.first) #Remove page title
        end
        @elements = node_elements
        @front_matter = node.front_matter
        @name = node.name
      end

      def body
        elements_before_smartdown = elements.take_while{|element| !smartdown_element?(element)}
        build_govspeak(elements_before_smartdown)
      end

      def devolved_body
        elements_after_smartdown = elements.drop_while{|element| !smartdown_element?(element)}
        build_govspeak(elements_after_smartdown)
      end

      def next_nodes
        elements.select{ |element| element.is_a? Smartdown::Model::NextNodeRules }
      end

      def permitted_next_nodes
        next_nodes
      end

    private

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
        GovspeakPresenter.new(markdown_elements.map(&:content).join("\n")).html
      end
    end
  end
end
