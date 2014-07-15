module Smartdown
  module Api
    class Processor
      def initialize(directory_input)
        @directory_input = directory_input
      end

      def call(responses)
        flow = Smartdown::Parser::FlowInterpreter.new(directory_input).interpret
        engine = Smartdown::Engine.new(flow)
        end_state = engine.process(responses)
        State.new(flow, end_state)
      end

    private

      attr_reader :directory_input

    end
  end
end
