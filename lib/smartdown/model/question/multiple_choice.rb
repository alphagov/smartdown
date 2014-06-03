require 'smartdown/util/hash'
require 'smartdown/model/indeterminate_next_node'

module Smartdown
  module Model
    module Question
      class MultipleChoice
        include Smartdown::Util::Hash
        attr_accessor :name, :body, :choices

        def initialize(name, options = {})
          @name = name
          @body = options[:body] || ""
          @choices = duplicate_and_normalize_hash(options[:choices] || {})
          @next_node = nil
        end

        def add_choice(name, value)
          @choices[name.to_s] = value
        end

        def transition(state, input)
          raise Smartdown::Model::IndeterminateNextNode unless @next_node
          state
            .put(:path, state.get(:path) + [state.get(:current_node)])
            .put(:responses, state.get(:responses) + [input])
            .put(name_as_state_variable, input)
            .put(:current_node, @next_node)
        end

        def next_node(node)
          @next_node = node
        end

        def valid_choice?(choice)
          @choices.keys.include?(choice.to_s)
        end

        def parse_input(raw_input)
          raise SmartAnswer::InvalidResponse, "Illegal option #{raw_input} for #{name}", caller unless valid_choice?(raw_input)
          super
        end

      private
        def name_as_state_variable
          name.gsub('?', '')
        end
      end
    end
  end
end
