require 'smartdown/model/answer/multiple_option'

module Smartdown
  module Model
    module Element
      module Question
        class MultipleOption < Struct.new(:name, :choices, :alias)
          def answer_type
            Smartdown::Model::Answer::MultipleOption
          end
        end
      end
    end
  end
end
