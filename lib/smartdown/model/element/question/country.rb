require 'smartdown/model/answer/country'

module Smartdown
  module Model
    module Element
      module Question
        class Country < Struct.new(:name, :countries, :alias)
          def answer_type
            Smartdown::Model::Answer::Country
          end
        end
      end
    end
  end
end
