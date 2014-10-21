require_relative "base"

module Smartdown
  module Model
    module Answer
      class MultipleChoice < Base
        def value_type
          ::String
        end

        def humanize
          question.choices.fetch(value)
        end
      end
    end
  end
end
