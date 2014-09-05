module Smartdown
  module Model
    module Predicate
      Named = Struct.new(:name) do
        def evaluate(state)
            state.get(name)
        end
      end
    end
  end
end
