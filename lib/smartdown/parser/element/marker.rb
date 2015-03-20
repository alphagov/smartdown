require 'smartdown/parser/base'

module Smartdown
  module Parser
    module Element
      class Marker < Base
        rule(:marker) {
          str('{{marker: ') >>
          identifier.as(:marker) >>
          str('}}') >>
          line_ending
        }

        root(:marker)
      end
    end
  end
end
