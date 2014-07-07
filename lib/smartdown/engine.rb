require 'smartdown/engine/transition'

module Smartdown
  class Engine
    attr_reader :flow

    def initialize(flow)
      @flow = flow
    end

    def start_state
      Smartdown::Model::State.new(current_node: flow.coversheet.name)
    end

    def process(responses)
      responses.inject(start_state) do |input, state|
        current_node = flow.node(state.get(:current_node))
        Transition.new(state, current_node, input).next_state
      end
    end
  end
end
