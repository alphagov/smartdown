module Smartdown
  module Model
    class Flow
      extend Forwardable

      attr_reader :nodes
      attr_reader :coversheet

      def initialize(coversheet, nodes = [])
        @coversheet = coversheet
        @nodes = nodes
      end

      def_delegator :coversheet, :name

      def start_state
        @state ||= Smartdown::Model::State.new(current_node: questions.first.name)
      end

      def process(responses)
        responses.inject(start_state) do |state, input|
          node(state.get(:current_node)).transition(state, input)
        end
      end

      def node(node_name)
        @questions.find {|q| q.name.to_s == node_name.to_s } || raise("Unable to find #{node_name}")
      end
    end
  end
end
