require 'smartdown'
require 'smartdown/engine'
require 'smartdown/api/state'
require 'smartdown/api/coversheet'
require 'smartdown/api/question_page'
require 'smartdown/api/outcome'

module Smartdown
  module Api
    class Flow

      def initialize(name)
        @name = name
        coversheet_path = Rails.root.join('lib', 'smartdown_flows', @name, "#{name}.txt")
        input = Smartdown::Parser::DirectoryInput.new(coversheet_path)
        @smartdown_flow = Smartdown::Parser::FlowInterpreter.new(input).interpret
        @engine = Smartdown::Engine.new(@smartdown_flow)
      end

      def state(started, responses)
        state = smartdown_state(started, responses)
        State.new(transform_node(node_by_name(state.get(:current_node))),
                  previous_question_nodes_for(state),
                  responses
        )
      end

      def title
        coversheet.title
      end

      def meta_description
        front_matter.meta_description
      end

      def need_id
        front_matter.satisfies_need
      end

      def status
        front_matter.status
      end

      def draft?
        status == 'draft'
      end

      def transition?
        status == 'transition'
      end

      def published?
        status == 'published'
      end

      def nodes
        @smartdown_flow.nodes.map{ |node| transform_node(node) }
          .select{ |node| (node.is_a? Smartdown::Api::QuestionPage) ||
                          (node.is_a? Smartdown::Api::Outcome)
        }
      end

      def question_pages
        nodes.select{ |node| node.is_a? Smartdown::Api::QuestionPage }
      end

      def outcomes
        nodes.select{ |node| node.is_a? Smartdown::Api::Outcome}
      end

    private

      def transform_node(node)
        if node.elements.any?{|element| element.is_a? Smartdown::Model::Element::StartButton}
          Smartdown::Api::Coversheet.new(node)
        elsif node.elements.any?{|element| element.is_a? Smartdown::Model::NextNodeRules}
          if node.elements.any?{|element| element.is_a? Smartdown::Model::Element::Question}
            Smartdown::Api::QuestionPage.new(node)
          else
            #TODO: support other types of questions
          end
        else
          Smartdown::Api::Outcome.new(node)
        end
      end

      def coversheet
        @coversheet ||= Smartdown::Api::Coversheet.new(@smartdown_flow.coversheet)
      end

      def front_matter
        @front_matter ||= coversheet.front_matter
      end

      def smartdown_state(started, responses)
        smartdown_responses = responses.clone
        if started
          smartdown_responses.unshift('y')
        end
        @engine.process(smartdown_responses)
      end

      def node_by_name(node_name)
        @smartdown_flow.node(node_name)
      end

      def previous_question_nodes_for(state)
        node_path = state.get('path')
        return [] if node_path.empty?

        node_path[1..-1].map do |node_name|
          node_by_name(node_name)
        end
      end

    end
  end
end
