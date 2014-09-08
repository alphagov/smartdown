module Smartdown
  module Model
    module Answer
      class Base
        extend Forwardable

        def_delegators :value, :to_s

        def ==(other)
          value == parse_value(other)
        end

        def <(other)
          value < parse_value(other)
        end

        def >(other)
          value > parse_value(other)
        end

        def <=(other)
          value <= parse_value(other)
        end

        def >=(other)
          value >= parse_value(other)
        end

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
