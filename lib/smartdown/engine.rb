require 'smartdown/engine/transition'
require 'smartdown/engine/state'
require 'smartdown/engine/node_presenter'
require 'smartdown/model/predicate/otherwise'

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
      {}.merge(@initial_state)
    end

    def process(unprocessed_responses, test_start_state = nil)
      state = test_start_state || build_start_state   

      while !unprocessed_responses.empty? do
        current_node = flow.node(state.get(:current_node))
        if current_node.is_start_page_node?
          # If it's a start page node, we've got to do something different because of the preceeding 'y' answer
          answers = unprocessed_responses.shift(1)
        else
          answers = current_node.questions.map do |question|
            question.answer_type.new(unprocessed_responses.shift, question)
          end
          if answers.any?(&:invalid?)
            state = state.put(:current_answers, answers)
            break
          end
        end
        
        transition = Transition.new(state, current_node, answers)
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
