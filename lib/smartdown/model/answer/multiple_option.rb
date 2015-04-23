require_relative "base"

module Smartdown
  module Model
    module Answer
      class MultipleOption < Base
        def value_type
          ::String
        end

        def humanize
          value.map { |v| question.choices.fetch(v) }
        end

        private
        def parse_value(value)
          # check_value_not_nil(value)
          # if valid?
          #   unless question.choices.keys.include? value
          #     @error = "Invalid choice"
          #   end
          # end
          value.split(',')
        end
      end
    end
  end
end
