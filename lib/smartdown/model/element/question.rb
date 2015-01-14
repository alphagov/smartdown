require 'forwardable'
require 'smartdown/api/multiple_choice'
require 'smartdown/api/date_question'
require 'smartdown/api/country_question'
require 'smartdown/api/salary_question'
require 'smartdown/api/text_question'
require 'smartdown/api/postcode_question'
require 'smartdown/api/money_question'

module Smartdown
  module Model
    module Element
      module Question

        def self.create_question_answer elements, response=nil
          constants.find do |symbol|
            question_type = const_get(symbol)

            if element = elements.find {|e| e.is_a?(question_type) }
              question = question_model(symbol)
              answer = response ? element.answer_type.new(response, element) : nil
              return [question.new(elements), answer]
            end
          end
          return [nil, nil]
        end

        private

        def self.question_model symbol
          unless Smartdown::Api.const_defined?(symbol)
            symbol = (symbol.to_s + 'Question').to_sym
          end
          Smartdown::Api.const_get(symbol)
        end

      end
    end
  end
end

