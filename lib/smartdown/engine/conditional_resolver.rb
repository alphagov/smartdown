module Smartdown
  class Engine
    class ConditionalResolver
      def call(node, state)
        node.dup.tap do |new_node|
          new_node.elements = resolve_conditionals(node.elements, state)
        end
      end

    private
      def evaluate(conditional, state)
        if conditional.predicate.evaluate(state)
          conditional.true_case
        else
          conditional.false_case
        end
      end

      def resolve_conditionals(elements, state)
        elements.map do |element|
          if element.is_a?(Smartdown::Model::Element::Conditional)
            evaluate(element, state)
          else
            element
          end
        end.flatten
      end
    end
  end
end
