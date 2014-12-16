require 'smartdown/model/answer/postcode'

module Smartdown
  module Model
    module Element
      module Question
        class Postcode < Struct.new(:name, :alias)
          def answer_type
            Smartdown::Model::Answer::Postcode
          end
        end
      end
    end
  end
end
