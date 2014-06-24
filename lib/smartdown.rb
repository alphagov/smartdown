require 'smartdown/parser/parser'

module Smartdown
  def self.parse(coversheet_file)
    Smartdown::Parser::Parser.new(coversheet_file).parse
  end
end
