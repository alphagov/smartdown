module Smartdown
  module Model
    module Element
      module Question
        class MultipleChoice

          attr_reader :name, :choices

          def initialize(name, choices)
            @name = name
            @choices = choices
          end

          def response_label(value)
            choices.fetch(value)
          end

        end
      end
    end
  end
end
