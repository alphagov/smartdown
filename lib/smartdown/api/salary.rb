require 'smartdown/api/question'

module Smartdown
  module Api
    class Salary < Question
      def partial_template_name
        "salary_question"
      end
    end
  end
end
