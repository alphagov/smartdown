require 'smartdown/engine/transition'
require 'smartdown/engine/state'
require 'smartdown/engine/node_presenter'

module Smartdown
  class Engine
    attr_reader :flow

    def initialize(flow, initial_state = {})
      @flow = flow
      @initial_state = initial_state
    end

    def build_start_state
      Smartdown::Engine::State.new(
        default_predicates.merge(
          current_node: flow.name
        )
      )
    end

    def default_predicates
      {
        otherwise: ->(_) { true }
      }.merge(@initial_state)
    end

    def process(raw_responses, test_start_state = nil)
      state = test_start_state || build_start_state
      unprocessed_responses = raw_responses
      while !unprocessed_responses.empty? do
        current_node = flow.node(state.get(:current_node))

        if current_node.elements.any?{|element| element.class.to_s.include?("Smartdown::Model::Element::StartButton") }
          # If it's a start page node, we've got to do something different because of the preceeding 'y' answer
          transition = Transition.new(state, current_node, unprocessed_responses.shift(1))
        else
          questions = current_node.elements.select{|element|
            element.class.to_s.include?("Smartdown::Model::Element::Question")
          }

          answers = questions.map do |question|
            question.answer_type.new(question, unprocessed_responses.shift)
          end

          transition = Transition.new(state, current_node, answers)
        end
        state = transition.next_state
      end
      state
    end

    def evaluate_node(state)
      current_node = flow.node(state.get(:current_node))
      NodePresenter.new.present(current_node, state)
    end
  end
end
