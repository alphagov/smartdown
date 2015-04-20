require "json"
require "smartdown/model/scenarios/scenario_set"
require "smartdown/model/scenarios/scenario"
require "smartdown/model/scenarios/question"

module Smartdown
  module Parser
    class ScenarioSetInterpreter
      def initialize(scenario_string)
        @scenario_lines = scenario_string.split("\n")
      end

      def scenario
        Smartdown::Model::Scenarios::Scenario.new(
          description,
          question_groups,
          outcome,
          markers,
          exact_markers
        )
      end

      def description_lines
        @scenario_lines.select{ |line| line.start_with?("#") }
      end

      def description
        description_lines.map do |description_line|
          description_line[1..-1].strip
        end.join(";")
      end

      def question_groups
        question_pages = group_questions_by_page(@scenario_lines[first_question..last_question])
        question_groups = question_pages.map { |question_page| interpret_question_page(question_page) }
      end

      def last_question
        @scenario_lines.rindex { |line| line.match(/(\s\s\S*:)|(- \S*:)/) }
      end

      def first_question
        @scenario_lines.index { |line| line.match(/(\s\s\S*:)|(- \S*:)/) }
      end

      def outcome
        @scenario_lines[last_question + 1]
      end

      def has_markers?
        @scenario_lines.any? { |line| line.match(/(has markers:|has marker:)/) }
      end

      def has_exact_markers?
        @scenario_lines.any? { |line| line.match(/(exact markers:|exact marker:)/) }
      end

      def markers
        if has_markers?
          marker_line = @scenario_lines.find { |line| line.match(/(has markers:|has marker:)/) }
          comma_sperated_markers = marker_line.slice(marker_line.index(":") + 1, marker_line.size)
          comma_sperated_markers.split(',').map(&:strip)
        else
          []
        end
      end

      def exact_markers
        if has_exact_markers?
          marker_line = @scenario_lines.find { |line| line.match(/(exact markers:|exact marker:)/) }
          comma_sperated_markers = marker_line.slice(marker_line.index(":") + 1, marker_line.size)
          comma_sperated_markers.split(',').map(&:strip)
        else
          []
        end
      end

    private

      def group_questions_by_page(lines)
        result = []
        lines.each do |scenario_line|
          if scenario_line.start_with?("-")
            result << [scenario_line[1..-1]]
          else
            result.last << scenario_line
          end
        end
        result
      end

      def interpret_question_page(question_page)
        question_page.map { |question|
          interpret_question(question)
        }
      end

      def interpret_question(question_string)
        name, answer = question_string.split(":").map(&:strip)
        Smartdown::Model::Scenarios::Question.new(
          name,
          answer,
        )
      end
    end
  end
end
