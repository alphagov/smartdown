require_relative "base"

module Smartdown
  module Model
    module Answer
      class Text < Base
        def value_type
          ::String
        end
      end
    end
  end
end
