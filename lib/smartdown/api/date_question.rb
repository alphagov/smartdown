require 'smartdown/api/question'

module Smartdown
  module Api
    class DateQuestion < Question
      extend Forwardable
      DEFAULT_START_YEAR = Time.now.year - 1
      DEFAULT_END_YEAR = Time.now.year + 3

      def start_year
        parse_date(from) || DEFAULT_START_YEAR
      end

      def end_year
        parse_date(to) || DEFAULT_END_YEAR
      end

    private

      delegate [:to, :from] => :question_element

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
