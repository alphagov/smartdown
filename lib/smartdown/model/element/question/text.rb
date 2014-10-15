require 'smartdown/model/answer/text'

module Smartdown
  module Model
    module Element
      module Question
        class Text < Struct.new(:name)
          def answer_type
            Smartdown::Model::Answer::Text
          end
        end
      end
    end
  end
end
