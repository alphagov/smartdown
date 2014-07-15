module Smartdown
  module API
    class State
      def initialize(flow, engine_state)
        @flow = flow
        @engine_state = engine_state
      end

    private
      attr_reader :flow, :engine_state

    end
  end
end
