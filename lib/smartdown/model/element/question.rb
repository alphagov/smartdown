module Smartdown
  module Model
    module Element
      module Question

        def self.create_question_answer elements, response
          constants.find do |symbol|
            question_type = const_get(symbol)

            if element = elements.find {|e| e.is_a?(question_type) }
              question = Smartdown::Api.const_get(symbol)
              answer = element.answer_type.new(response, element)
              return [question.new(elements), answer]
            end
          end
          return [nil, nil]
        end

      end
    end
  end
end

