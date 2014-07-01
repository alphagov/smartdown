require 'smartdown/parser/base'
require 'smartdown/parser/predicates'

module Smartdown
  module Parser
    class Rules < Base
      rule(:rule) {
        bullet >> optional_space >> Smartdown::Parser::Predicates.new.as(:predicate) >> optional_space >> str("=>") >> optional_space >> identifier.as(:outcome)
      }

      rule(:rules) {
        rule.as(:rule).repeat
      }

      root(:rules)
    end
  end
end
