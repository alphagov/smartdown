module Smartdown
  module Model
    module Predicate
      Combined = Struct.new(:predicates) do
        def evaluate(state)
            predicates.map { |predicate| predicate.evaluate(state) }.all?
        end
      end
    end
  end
end
