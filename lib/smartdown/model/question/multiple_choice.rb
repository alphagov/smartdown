require 'smartdown/util/hash'
require 'smartdown/errors'

module Smartdown
  module Model
    module Question
      class MultipleChoice
        include Smartdown::Util::Hash
        attr_accessor :name, :choices

        def initialize(name, choices = {})
          @name = name
          @choices = duplicate_and_normalize_hash(choices)
        end

        def add_choice(name, value)
          @choices[name.to_s] = value
        end

        def valid_choice?(choice)
          @choices.keys.include?(choice.to_s)
        end

        def parse_input(raw_input)
          if valid_choice?(raw_input)
            raw_input
          else
            raise Smartdown::InvalidResponse, "Illegal option #{raw_input} for #{name}", caller
          end
        end

        def ==(other)
          other.is_a?(self.class) && other.name == self.name && other.choices == self.choices
        end

      private
        def name_as_state_variable
          name.gsub('?', '')
        end
      end
    end
  end
end
