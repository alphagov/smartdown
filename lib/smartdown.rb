require 'smartdown/parser/flow_interpreter'
require 'smartdown/api/directory_input'

module Smartdown
  def self.parse(coversheet_file)
    input = Smartdown::Api::DirectoryInput.new(coversheet_file)
    Smartdown::Parser::FlowInterpreter.new(input).interpret
  end
end
