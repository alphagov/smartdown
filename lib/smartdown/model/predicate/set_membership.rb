module Smartdown
  module Model
    module Predicate
      SetMembership = Struct.new(:varname, :values) do
        def evaluate(state)
            values.include?(state.get(varname))
        end
      end
    end
  end
end
