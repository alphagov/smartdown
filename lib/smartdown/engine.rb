require 'smartdown/engine/transition'
require 'smartdown/engine/state'

module Smartdown
  class Engine
    attr_reader :flow

    def initialize(flow)
      @flow = flow
    end

    def default_start_state
      Smartdown::Engine::State.new(current_node: flow.name)
    end

    def process(responses, start_state = nil)
      responses.inject(start_state || default_start_state) do |state, input|
        current_node = flow.node(state.get(:current_node))
        Transition.new(state, current_node, input).next_state
      end
    end
  end
end
