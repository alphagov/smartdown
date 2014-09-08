require 'smartdown/model/answer/date'

module Smartdown
  module Model
    module Element
      module Question
        class Date < Struct.new(:name)
          def answer_type
            Smartdown::Model::Answer::Date
          end
        end
      end
    end
  end
end
