require 'pathname'
require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/transform'

module Smartdown
  module Parser
    class Parser
      attr_reader :coversheet_file

      def initialize(coversheet_file)
        @coversheet_file = coversheet_file
      end

      def parse
        # parse all outcomes

        # create flow model out of all that stuff
        Smartdown::Model::Flow.new(coversheet, questions)
      end

    private
      def basedir
        Pathname.new(coversheet_file).dirname
      end

      def node_name_from_filename(filename)
        File.basename(filename, ".txt")
      end

      def parse_node(filename, page_class)
        data = File.read(filename)
        parsed = Smartdown::Parser::NodeParser.new.parse(data)
        transform = Smartdown::Parser::Transform.new
        transform.apply(parsed,
          page_class: page_class,
          node_name: node_name_from_filename(filename)
        )
      end

      def coversheet
        parse_node(coversheet_file, Smartdown::Model::Node)
      end

      def parse_question(filename)
        parse_node(filename, Smartdown::Model::Node)
      end

      def questions
        Dir[basedir + "questions" + "*.txt"].map do |filename|
          parse_question(filename)
        end
      end
    end
  end
end
