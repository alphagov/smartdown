# encoding: utf-8
require_relative "base"

module Smartdown
  module Model
    module Answer
      class Salary < Base
        attr_reader :period, :amount_per_period

        FORMAT_REGEX = /^£?\W*([\d|,|]+[\.]?[\d]*)[-|\W*per\W*](week|month|year)$/

        def value_type
          ::Float
        end

        def to_s
          "#{'%.2f' % amount_per_period}-#{period}"
        end

        def humanize
          whole, decimal = separate_by_comma(amount_per_period)
          if decimal == "00"
            "£#{whole} per #{period}"
          else
            "£#{whole}.#{decimal} per #{period}"
          end
        end

      private
        def parse_value(value)
          matched_value = value.strip.match FORMAT_REGEX
          unless matched_value
            @error = "Invalid format"
            return
          end
          @amount_per_period, @period = *matched_value[1..2]
          @amount_per_period = @amount_per_period.gsub(",","").to_f
          yearly_total
        end

        def yearly_total
          case period
          when "week"
            amount_per_period * 52
          when "month"
            amount_per_period * 12
          when "year"
            amount_per_period
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
