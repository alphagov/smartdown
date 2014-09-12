require 'smartdown/parser/input_set'

module Smartdown
  module Parser
    class SnippetPreParser
      class SnippetNotFound < StandardError; end

      attr_reader :input_data

      def initialize(input_data)
        @input_data = input_data
      end

      def parse
        InputSet.new({
          coversheet: parse_node_input(input_data.coversheet),
          questions: input_data.questions.map { |question_data| parse_node_input(question_data) },
          outcomes: input_data.outcomes.map { |outcome_data| parse_node_input(outcome_data) },
          snippets: input_data.snippets,
          scenarios: input_data.scenarios,
        })
      end

      def self.parse(input_data)
        self.new(input_data).parse
      end

    private
      def parse_node_input(node_input)
        InputData.new(node_input.name, parse_content(node_input.read))
      end

      def parse_content(content)
        content.gsub(/\{\{snippet:\W?(.*)\}\}/i) { |_|
          parse_content(get_snippet($1).read.strip)
        }
      end

      def get_snippet(snippet_name)
        input_data.snippets.find { |snippet| snippet.name == snippet_name } or raise SnippetNotFound.new(snippet_name)
      end
    end
  end
end
