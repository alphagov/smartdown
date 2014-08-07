require 'smartdown/engine/conditional_resolver'
require 'smartdown/engine/interpolator'

module Smartdown
  class Engine
    class NodePresenter
      PRESENTERS = [
        Smartdown::Engine::ConditionalResolver.new,
        Smartdown::Engine::Interpolator.new
      ]

      def present(unpresented_node, state)
        PRESENTERS.inject(unpresented_node) do |node, presenter_class|
          presenter_class.call(node, state)
        end
      end
    end
  end
end
