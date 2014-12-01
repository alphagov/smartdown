module Smartdown
  module Model
    module Predicate
      OrOperation = Struct.new(:predicates) do
        def evaluate(state)
          predicates.map { |predicate| predicate.evaluate(state) }.any?
        end

        def humanize
          "(#{predicates.map { |p| p.humanize }.join(' OR ')})"
        end
      end
    end
  end
end
