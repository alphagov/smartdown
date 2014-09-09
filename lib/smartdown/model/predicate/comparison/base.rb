module Smartdown
  module Model
    module Predicate
      module Comparison
        Base = Struct.new(:varname, :value) do
          def evaluate(state)
          end
        end
      end
    end
  end
end
