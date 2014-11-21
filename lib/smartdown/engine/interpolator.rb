module Smartdown
  class Engine
    class Interpolator
      def call(node, state)
        node.dup.tap do |new_node|
          new_node.elements = interpolate_elements(node.elements, state)
        end
      end

    private
      def interpolator_for(element)
        INTERPOLATOR_CONFIG.fetch(element.class, DEFAULT_INTERPOLATOR).new(element)
      end

      def interpolate_elements(elements, state)
        elements.map do |element|
          interpolator_for(element).call(state)
        end
      end

      class NullElementInterpolator
        attr_reader :element

        def initialize(element)
          @element = element
        end

        def call(state)
          element
        end
      end

      class ElementContentInterpolator < NullElementInterpolator
        def call(state)
          element.dup.tap do |e|
            e.content = interpolate(e.content, state)
          end
        end

      private
        def interpolate(text, state)
          text.to_s.gsub(/%{([^}]+)}/) do |_|
            term = resolve_term($1, state)
            if term.is_a?(Smartdown::Model::Answer::Base)
              term = term.humanize
            end
            term
          end
        end

        def resolve_term(interpolation, state)
          begin
              parsed = Smartdown::Parser::Predicates.new.parse(interpolation)
              Smartdown::Parser::NodeTransform.new.apply(parsed, {}).evaluate(state)
            rescue Parslet::ParseFailed
              state.get(interpolation)
            end
        end
      end

      INTERPOLATOR_CONFIG = {
        Smartdown::Model::Element::MarkdownParagraph => ElementContentInterpolator,
        Smartdown::Model::Element::MarkdownHeading => ElementContentInterpolator
      }

      DEFAULT_INTERPOLATOR = NullElementInterpolator

    end
  end
end
