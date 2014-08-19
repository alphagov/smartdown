require 'smartdown/engine/transition'
require 'smartdown/engine/state'
require 'smartdown/engine/node_presenter'

module Smartdown
  class Engine
    attr_reader :flow

    def initialize(flow)
      @flow = flow
    end

    def default_start_state
      Smartdown::Engine::State.new(
        default_predicates.merge(
          current_node: flow.name
        )
      )
    end

    def default_predicates
      {
        otherwise: ->(_) { true }
      }
    end

    def process(responses, start_state = nil)
      state = start_state || default_start_state
      unprocessed_responses = responses
      while !unprocessed_responses.empty? do
        nb_questions = 0
        current_node = flow.node(state.get(:current_node))
        nb_questions += current_node.elements.select{|element|
          element.is_a? Smartdown::Model::Element::Question
        }.count

        #There is at least one relevant input per transition for now:
        #Transition from start to first question relies on an input, regardless of its value
        nb_relevant_inputs = [nb_questions, 1].max
        input_array = unprocessed_responses.take(nb_relevant_inputs)
        unprocessed_responses = unprocessed_responses.drop(nb_relevant_inputs)

        transition = Transition.new(state, current_node, input_array)
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
