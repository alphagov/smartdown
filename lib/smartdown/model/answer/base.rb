module Smartdown
  module Model
    module Answer
      class Base
        extend Forwardable
        include Comparable

        def_delegators :value, :to_s, :to_i, :to_f, :+, :-, :*, :/

        def value_type
          ::String
        end

        def <=>(other)
          value <=> parse_comparison_object(other)
        end

        attr_reader :question, :value

        def initialize(question, value)
          @question = question
          @value = parse_value(value)
        end

      private
        def parse_comparison_object(comparison_object)
          if comparison_object.is_a? Base
            comparison_object.value
          elsif comparison_object.is_a? value_type
            comparison_object
          else
            parse_value(comparison_object)
          end
        end

        def parse_value(value)
          value
        end
      end
    end
  end
end
