module Smartdown
  module Model
    module Predicate
      Equality = Struct.new(:varname, :expected_value) do
        def evaluate(state)
            state.get(varname) == expected_value
        end
      end
    end
  end
end
