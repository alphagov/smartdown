require 'smartdown/util/hash'
require 'smartdown/errors'

module Smartdown
  module Model
    class NextNodeRules
      def initialize(node_name)
        @node_name = node_name
      end

      def transition(state, input)
        raise Smartdown::IndeterminateNextNode unless @next_node
        state
          .put(:path, state.get(:path) + [state.get(:current_node)])
          .put(:responses, state.get(:responses) + [input])
          .put(name_as_state_variable, input)
          .put(:current_node, @next_node)
      end

      def next_node(node)
        @next_node = node
      end

    private
      def name_as_state_variable
        @node_name.gsub('?', '')
      end
    end
  end
end
