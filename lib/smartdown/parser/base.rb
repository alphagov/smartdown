require 'parslet'

module Smartdown
  module Parser
    class Base < Parslet::Parser
      rule(:eof) { any.absent? }
      rule(:ws_char) { space_char | str("\t") }
      rule(:space_char) { str(" ") }
      rule(:non_ws_char) { match('\S') }
      rule(:carriage_return) { str("\n") | str("\r") }
      rule(:newline) { ws >> carriage_return }
      rule(:line_ending) { eof | newline }

      rule(:optional_space) { space_char.repeat }
      rule(:some_space) { space_char.repeat(1) }
      rule(:ws) { ws_char.repeat }
      rule(:non_ws) { non_ws.repeat }
      rule(:comma) { str(",") }
      rule(:colon) { str(":") }

      rule(:whitespace_terminated_string) {
        non_ws_char >> (non_ws_char | space_char.repeat(1) >> non_ws_char).repeat
      }

      rule(:identifier) {
        match('[a-zA-Z_0-9-]').repeat(1)
      }

      rule(:question_identifier) {
        identifier >> str('?').maybe
      }

      rule(:bullet) {
        match('[*-]')
      }

    end
  end
end
