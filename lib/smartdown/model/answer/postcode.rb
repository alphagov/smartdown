# encoding: utf-8
require_relative "base"
require "uk_postcode"

module Smartdown
  module Model
    module Answer
      class Postcode < Base

        def value_type
          ::String
        end

        def humanize
          value
        end

      private
        def parse_value(value)
          postcode = UKPostcode.new(value)
          if !postcode.valid?
            @error = "Invalid postcode"
          elsif !postcode.full?
            @error = "Please enter a full postcode"
          end
          value
        end
      end
    end
  end
end
