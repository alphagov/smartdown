require 'smartdown/model/answer/multiple_choice'

module Smartdown
  module Model
    module Element
      module Question
        class MultipleChoice < Struct.new(:name, :choices)
          def answer_type
            Smartdown::Model::Answer::MultipleChoice
          end
        end
      end
    end
  end
end
