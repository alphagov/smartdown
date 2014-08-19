require 'smartdown/model/predicate/comparison/base'

module Smartdown
  module Model
    module Predicate
      module Comparison
        class Less < Base
          def evaluate(variable)
            variable < value
          end
        end
      end
    end
  end
end
