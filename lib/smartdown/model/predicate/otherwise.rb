module Smartdown
  module Model
    module Predicate
      class Otherwise
        def evaluate(state)
            true
        end

        def ==(o)
          o.class == self.class
        end
      end
    end
  end
end
