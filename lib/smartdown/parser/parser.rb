require 'smartdown/model/flow'
require 'smartdown/model/coversheet'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/transform'

module Smartdown
  module Parser
    class Parser
      def parse(coversheet_file)
        # parse coversheet
        coversheet = parse_coversheet(coversheet_file)
        # parse all questions
        # parse all outcomes
        # create flow model out of all that stuff
        Smartdown::Model::Flow.new(coversheet)
      end

    private
      def parse_coversheet(coversheet_file)
        parser = Smartdown::Parser::NodeParser.new
        parsed = parser.parse(File.read(coversheet_file))

        transform = Smartdown::Parser::Transform.new
        transform.apply(parsed).tap do |coversheet|
          coversheet.name = flow_name_from_filename(coversheet_file)
        end
      end

      def flow_name_from_filename(file)
        File.basename(file, ".txt")
      end
    end
  end
end
