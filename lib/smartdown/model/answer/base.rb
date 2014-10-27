module Smartdown
  module Model
    module Answer
      class Base
        extend Forwardable
        include Comparable

        def_delegators :value, :to_s, :humanize, :to_i, :to_f, :+, :-, :*, :/

        def value_type
          ::String
        end

        def <=>(other)
          value <=> parse_comparison_object(other)
        end

        attr_reader :question, :value, :error

        def initialize(value, question=nil)
          @value = parse_value(value)
          @question = question
        end

        def valid?
          @error.nil?
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
          unless value
            @error = "Please answer this question"
          end
          value
        end
      end
    end
  end
end
