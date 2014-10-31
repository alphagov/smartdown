# encoding: utf-8
#TODO: this is no technically an answer (only used for plugin formatting for now)
#since we will have money questions in the near future, this todo should be removed, and the
#require in interpolator.rb removed

require_relative "base"

module Smartdown
  module Model
    module Answer
      class Money < Base
        def value_type
          ::Float
        end

        def humanize
          "£#{'%.2f' % value}".gsub(/(\d)(?=(\d\d\d)+(?!\d))/) do |digit_to_delimit|
            "#{digit_to_delimit},"
          end
        end
      end
    end
  end
end
