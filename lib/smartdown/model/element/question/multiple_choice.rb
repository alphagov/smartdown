module Smartdown
  module Model
    module Element
      module Question
        MultipleChoice = Struct.new(:name, :choices) do
          def response_label(value)
            choices.fetch(value)
          end
        end
      end
    end
  end
end
