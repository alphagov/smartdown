module Smartdown
  module Model
    module Predicate
      SetMembership = Struct.new(:varname, :values) do
        def evaluate(state)
          values.include?(state.get(varname))
        end

        def humanize
          "#{varname} in [#{values.join(", ")}]"
        end
      end
    end
  end
end
