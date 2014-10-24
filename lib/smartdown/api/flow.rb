require 'smartdown'
require 'smartdown/engine'
require 'smartdown/api/state'
require 'smartdown/api/coversheet'
require 'smartdown/api/question_page'
require 'smartdown/api/outcome'
require 'smartdown/parser/scenario_sets_interpreter'

module Smartdown
  module Api
    class Flow

      attr_reader :scenario_sets

      def initialize(smartdown_input, initial_state = {})
        @smartdown_flow = Smartdown::Parser::FlowInterpreter.new(smartdown_input).interpret
        @engine = Smartdown::Engine.new(@smartdown_flow, initial_state)
        @scenario_sets = Smartdown::Parser::ScenarioSetsInterpreter.new(smartdown_input).interpret
      end

      def state(started, responses)
        state = smartdown_state(started, responses)
        State.new(transform_node(evaluate_node(node_by_name(state.get(:current_node)), state)),
                  previous_question_nodes_for(state),
                  responses
        )
      end

      def name
        @smartdown_flow.name
      end

      def title
        coversheet.title
      end

      def meta_description
        front_matter.fetch meta_description, nil
      end

      def need_id
        front_matter.fetch satisfies_need, nil
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

      def coversheet
        @coversheet ||= Smartdown::Api::Coversheet.new(@smartdown_flow.coversheet)
      end

    private

      def transform_node(node)
        if node.elements.any?{|element| element.is_a? Smartdown::Model::Element::StartButton}
          Smartdown::Api::Coversheet.new(node)
        elsif node.elements.any?{|element| element.is_a? Smartdown::Model::NextNodeRules}
          if node.elements.any?{|element| element.class.to_s.include?("Smartdown::Model::Element::Question")}
            Smartdown::Api::QuestionPage.new(node)
          else
            raise("Unknown node type: #{node.elements.map(&:class)}")
          end
        else
          Smartdown::Api::Outcome.new(node)
        end
      end

      def evaluate_node(node, state)
        Smartdown::Engine::NodePresenter.new.present(node, state)
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
          evaluate_node(node_by_name(node_name), state)
        end
      end

    end
  end
end
