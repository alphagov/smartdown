require 'smartdown/parser/directory_input'

module Smartdown
  module Api
    class DirectoryInput < Smartdown::Parser::DirectoryInput
      def initialize(coversheet_path)
        super(coversheet_path)
      end
    end
  end
end
