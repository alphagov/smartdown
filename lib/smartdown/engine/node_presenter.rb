require 'smartdown/engine/conditional_resolver'

module Smartdown
  class Engine
    class NodePresenter
      def present(node, state)
        Smartdown::Engine::ConditionalResolver.new.call(node, state)
      end
    end
  end
end
