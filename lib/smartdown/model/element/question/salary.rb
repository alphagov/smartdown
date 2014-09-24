require 'smartdown/model/answer/salary'

module Smartdown
  module Model
    module Element
      module Question
        class Salary < Struct.new(:name)
          def answer_type
            Smartdown::Model::Answer::Salary
          end
        end
      end
    end
  end
end
