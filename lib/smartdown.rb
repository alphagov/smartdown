require 'smartdown/parser/parser'

module Smartdown
  def self.parse(coversheet_file)
    Smartdown::Parser::Parser.new.parse(coversheet_file)
  end
end
