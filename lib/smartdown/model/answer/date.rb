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
          ::Date.parse(value)
        end
      end
    end
  end
end
