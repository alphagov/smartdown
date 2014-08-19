module Smartdown
  module Model
    module Element
      module Question
        Salary = Struct.new(:name) do
          def response_label(value)
            value
          end
        end
      end
    end
  end
end
