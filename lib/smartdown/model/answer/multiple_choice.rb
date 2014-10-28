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

        private
        def parse_value(value)
          check_value_not_nil(value)
          if valid?
            unless question.choices.keys.include? value
              @error = "Invalid choice"
            end
          end
          value
        end
      end
    end
  end
end
