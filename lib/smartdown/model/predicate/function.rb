module Smartdown
  module Model
    module Predicate
      Function = Struct.new(:name, :arguments) do
        def evaluate(state)
          state.get(name, false).call(*evaluate_arguments(state))
        end

        def humanize
          "#{name}(#{arguments.join(' ')})"
        end

      private

        def evaluate_arguments(state)
          # Should have an evaluatable "variable" object that matches identifier
          arguments.map do |argument|
            if argument.respond_to?(:evaluate)
              argument.evaluate(state)
            else
              state.get(argument)
            end
         end
        end
      end
    end
  end
end
