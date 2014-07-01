require 'smartdown/parser/flow_interpreter'
require 'smartdown/parser/directory_input'

module Smartdown
  def self.parse(coversheet_file)
    input = Smartdown::Parser::DirectoryInput.new(coversheet_file)
    Smartdown::Parser::FlowInterpreter.new(input).interpret
  end
end
