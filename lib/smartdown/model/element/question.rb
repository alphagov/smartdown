require 'forwardable'
require 'smartdown/api/multiple_choice'
require 'smartdown/api/date_question'
require 'smartdown/api/country_question'
require 'smartdown/api/money_question'
require 'smartdown/api/salary_question'
require 'smartdown/api/text_question'
require 'smartdown/api/postcode_question'

module Smartdown
  module Model
    module Element
      module Question

        class << self
          def create_question_answer elements, response=nil
            first_question_element(elements) do |element|
              question = create_question(elements, element)
              answer   = create_answer(response, element)
              return [question, answer]
            end
            return [nil, nil]
          end

          private

          def first_question_element elements
            constants.find do |symbol|
              question_type = const_get(symbol)

              if element = elements.find {|e| e.is_a?(question_type) }
                yield element
              end
            end
          end

          def create_question elements, element
            question_model(element).new(elements)
          end

          def question_model element
            Smartdown::Api.const_get question_model_name(element)
          end

          def question_model_name element
            symbol = element.class.name.split(':').last.to_sym
            name = (symbol.to_s + 'Question').to_sym
            name = symbol unless Smartdown::Api.const_defined?(name)
            name
          end

          def create_answer response, element
            response ? element.answer_type.new(response, element) : nil
          end

        end
      end
    end
  end
end

