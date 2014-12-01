module Smartdown
  module Model
    module Predicate
      NotOperation = Struct.new(:predicate) do
        def evaluate(state)
          !predicate.evaluate(state)
        end

        def humanize
          "NOT #{predicate.humanize}"
        end
      end
    end
  end
end
