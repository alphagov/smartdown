require 'smartdown/api/question'

module Smartdown
  module Api
    class DateQuestion < Question
      extend Forwardable

      def start_year
        parse_date(from) || default_start_year
      end

      def end_year
        parse_date(to) || default_end_year
      end

    private

      delegate [:to, :from] => :question_element

      def default_start_year
        Time.now.year - 1
      end

      def default_end_year
        Time.now.year + 3
      end

      def question_element
        @question_element ||= elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Date}
      end

      def parse_date(date_string)
        return nil unless date_string
        year = date_string.to_i
        if is_fixed_year?(year)
          year
        else
          Time.now.year + year
        end
      end

      def is_fixed_year?(int)
        int.abs >= 1000
      end
    end
  end
end
