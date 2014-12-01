module Smartdown
  module Model
    module Predicate
      AndOperation = Struct.new(:predicates) do
        def evaluate(state)
          predicates.map { |predicate| predicate.evaluate(state) }.all?
        end

        def humanize
          "(#{predicates.map { |p| p.humanize }.join(' AND ')})"
        end
      end
    end
  end
end
