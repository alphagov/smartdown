require_relative "base"

module Smartdown
  module Model
    module Answer
      class Date < Base
        def value_type
          ::Date
        end

        def to_s
          value.strftime("%Y-%-m-%-d")
        end

        def humanize
          value.strftime("%-d %B %Y")
        end

      private
        def parse_value(value)
          unless value
            @error = "Please answer this question"
            return
          end
          begin
            ::Date.parse(value)
          rescue ArgumentError
            @error = "Invalid date"
          end
        end
      end
    end
  end
end
