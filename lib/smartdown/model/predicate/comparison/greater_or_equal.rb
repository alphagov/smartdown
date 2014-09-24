require 'smartdown/model/predicate/comparison/base'
require 'date'

module Smartdown
  module Model
    module Predicate
      module Comparison
        class GreaterOrEqual < Base
          def evaluate(state)
            variable = state.get(varname)
            variable >= value
          end

          def humanize
            "#{varname} >= #{value}"
          end
        end
      end
    end
  end
end
