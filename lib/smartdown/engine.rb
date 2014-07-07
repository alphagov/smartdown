module Smartdown
  class Engine
    attr_reader :flow

    def initialize(flow)
      @flow = flow
    end

    def start_state
      Smartdown::Model::State.new(current_node: flow.coversheet.name)
    end

    def process(input_list)
      input_list.inject(start_state) do |input, state|
        current_node = flow.node(state.get(:current_node))
        transition(current_node, state, input)
      end
    end

    def transition(current_node, state, input)
      next_node = compute_next_node(current_node, input)
      raise Smartdown::IndeterminateNextNode unless next_node
      state
        .put(:path, state.get(:path) + [current_node.name])
        .put(:responses, state.get(:responses) + [input])
        .put(name_as_state_variable(current_node.name), input)
        .put(:current_node, next_node)
    end

    def compute_next_node
    end
  end
end
