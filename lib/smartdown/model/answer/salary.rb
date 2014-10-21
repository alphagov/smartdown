# encoding: utf-8
require_relative "base"

module Smartdown
  module Model
    module Answer
      class Salary < Base
        attr_reader :period, :amount_per_period

        def value_type
          ::Float
        end

        def to_s
          "#{'%.2f' % amount_per_period} per #{period}"
        end

        def humanize
          whole, decimal = separate_by_comma(amount_per_period)
          "£#{whole}.#{decimal} per #{period}"
        end

      private
        def parse_value(value)
          @amount_per_period, @period = value.split(/-|\W*per\W*/)
          @amount_per_period = @amount_per_period.to_f
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
          whole, decimal = ('%.2f' % number).split(".")
          whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
          rounded_up_decimal = "%02d" % decimal.to_i
          [whole_with_commas, rounded_up_decimal]
        end
      end
    end
  end
end
