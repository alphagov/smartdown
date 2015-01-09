# encoding: utf-8
require_relative "base"

module Smartdown
  module Model
    module Answer
      class Money < Base
        def value_type
          ::Float
        end

        def humanize
          number_string = "£#{'%.2f' % value}".gsub(/(\d)(?=(\d\d\d)+(?!\d))/) do |digit_to_delimit|
            "#{digit_to_delimit},"
          end
          number_string.end_with?(".00") ? number_string[0..-4] : number_string
        end
      end
    end
  end
end
