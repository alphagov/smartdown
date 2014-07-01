require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class FrontMatter < Base
        rule(:front_matter_line) {
          identifier.as(:name) >> str(":") >> ws >> whitespace_terminated_string.as(:value) >> line_ending
        }
        rule(:front_matter) {
          front_matter_line.repeat(1).as(:front_matter)
        }
        root(:front_matter)
      end
    end
  end
end
