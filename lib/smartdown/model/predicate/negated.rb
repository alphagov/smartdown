module Smartdown
  module Model
    module Predicate
      Negated = Struct.new(:predicate) do
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
