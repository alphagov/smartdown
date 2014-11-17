require 'smartdown/api/question'
require 'smartdown/model/element/question/country'

module Smartdown
  module Api
    class CountryQuestion < Question
      def options
        question = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Country}
        question.countries.map do |choice|
          OpenStruct.new(:label => choice[1], :value => choice[0])
        end
      end

      def name
        question = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::Country}
        question.name
      end

    end
  end
end
