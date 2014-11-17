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

        private
        def parse_value(value)
          check_value_not_nil(value)
          if valid?
            unless question.countries.keys.include? value
              @error = "Invalid country"
            end
          end
          value
        end
      end
    end
  end
end
