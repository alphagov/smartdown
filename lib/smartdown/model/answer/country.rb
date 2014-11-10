require_relative "base"

module Smartdown
  module Model
    module Answer
      class Country < Base
        def value_type
          ::String
        end

        def humanize
          question.countries[value]
        end
      end
    end
  end
end
