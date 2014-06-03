module Smartdown
  module Model
    class Flow
      attr_accessor :name
      attr_reader :questions

      def initialize(name)
        @name = name
        @questions = []
      end

      def add_question(question)
        @questions << question
      end

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
