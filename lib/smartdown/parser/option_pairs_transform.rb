module Smartdown
  module Parser
    module OptionPairs
      def self.transform(option_pairs)
        Hash[option_pairs.map { |option_pair|
          option_pair.values.map(&:to_s)
        }]
      end
    end
  end
end
