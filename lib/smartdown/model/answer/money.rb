# encoding: utf-8
require_relative "base"

module Smartdown
  module Model
    module Answer
      class Money < Base

        FORMAT_REGEX = /^£?\W*([\d|,|]+[\.]?[\d]*)$/

        def value_type
          ::Float
        end

        def to_s
          ('%.2f' % value).chomp('.00')
        end

        def humanize
          whole, decimal = separate_by_comma(value)
          if decimal == '00'
            "£#{whole}"
          else
            "£#{whole}.#{decimal}"
          end
        end

        private

        def parse_value value
          if value.is_a?(Float)
            value
          elsif value.is_a?(Fixnum)
            Float value
          else
            matched_value = value.strip.match FORMAT_REGEX
            if matched_value
              Float matched_value[1].gsub(',','')
            else
              @error = 'Invalid format'
              return
            end
          end
        end

        def separate_by_comma(number)
          left, right = ('%.2f' % number).split('.')
          left.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/) do |digit_to_delimit|
            "#{digit_to_delimit},"
          end
          [left, right]
        end
      end
    end
  end
end
