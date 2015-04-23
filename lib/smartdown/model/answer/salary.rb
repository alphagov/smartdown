# encoding: utf-8
require_relative "base"

module Smartdown
  module Model
    module Answer
      class Salary < Base
        attr_reader :period, :amount_per_period

        FORMAT_REGEX = Regexp.new(Money::FORMAT_REGEX.source.chomp('$') +
            /[-|\W*per\W*](week|month|year)$/.source)

        def value_type
          ::Float
        end

        def to_s
          "#{@money_per_period}-#{period}"
        end

        def humanize
          "#{@money_per_period.humanize} per #{period}"
        end

      private
        def parse_value(value)
          matched_value = value.strip.match FORMAT_REGEX
          unless matched_value
            @error = "Invalid format"
            return
          end
          amount_per_period, _, @period = *matched_value[1..3]

          @money_per_period = Money.new(amount_per_period)
          @amount_per_period = @money_per_period.value
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

      end
    end
  end
end
