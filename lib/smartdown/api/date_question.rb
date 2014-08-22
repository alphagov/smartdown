require 'smartdown/api/question'

module Smartdown
  module Api
    class DateQuestion < Question
      def partial_template_name
        "date_question"
      end

      def defaulted_day?
        false
      end

      def defaulted_month?
        false
      end

      def defaulted_year?
        false
      end

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
