module Smartdown
  module Model
    module Element
      module Question
        class Date

          attr_reader :name

          def initialize(name)
            @name = name
          end

          def response_label(value)
            value
          end

        end
      end
    end
  end
end
