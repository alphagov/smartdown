require 'smartdown/model/predicate/comparison/base'
require 'date'

module Smartdown
  module Model
    module Predicate
      module Comparison
        class LessOrEqual < Base
          def evaluate(variable)
            variable <= value
          end
        end
      end
    end
  end
end
