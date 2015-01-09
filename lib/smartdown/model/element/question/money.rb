require 'smartdown/model/answer/money'

module Smartdown
  module Model
    module Element
      module Question
        class Money < Struct.new(:name, :alias)
          def answer_type
            Smartdown::Model::Answer::Money
          end
        end
      end
    end
  end
end
