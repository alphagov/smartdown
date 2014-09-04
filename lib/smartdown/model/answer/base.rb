module Smartdown
  module Model
    module Answer
      class Base
        extend Forwardable

        def_delegators :value, :to_s, :==, :<, :>, :<=, :>=

        attr_reader :question, :value

        def initialize(question, value)
          @question = question
          @value = parse_value(value)
        end

      private
        def parse_value(value)
          value
        end
      end
    end
  end
end
