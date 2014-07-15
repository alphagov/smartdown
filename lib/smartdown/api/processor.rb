module Smartdown
  module API
    class Processor
      def initialize(coversheet_path)
        @coversheet_path = coversheet_path
      end

      def call(responses)
        input = Smartdown::Parser::DirectoryInput.new(coversheet_path)
        flow = Smartdown::Parser::FlowInterpreter.new(input).interpret
        engine = Smartdown::Engine.new(flow)
        end_state = engine.process(responses)
        State.new(flow, end_state)
      end

    private

      attr_reader :coversheet_path

    end
  end
end
