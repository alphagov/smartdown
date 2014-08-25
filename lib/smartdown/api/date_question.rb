require 'smartdown/api/question'

module Smartdown
  module Api
    class DateQuestion < Question
      def default
        Date.today
      end

      def start_date
        Date.today - 365
      end

      def end_date
        Date.today + 5*365
      end
    end
  end
end
