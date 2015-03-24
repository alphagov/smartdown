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
          markers
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
        lines = @scenario_lines - description_lines
        if has_markers?
          question_pages = group_questions_by_page(lines[0..-3])
        else
          question_pages = group_questions_by_page(lines[0..-2])
        end
        question_groups = question_pages.map { |question_page| interpret_question_page(question_page) }
      end

      def outcome
        if has_markers?
          @scenario_lines[@scenario_lines.size - 2]
        else
          @scenario_lines.last
        end
      end

      def has_markers?
        @scenario_lines.last.match(/(has markers:|has marker:)/)
      end

      def markers
        if has_markers?
          last_line = @scenario_lines.last
          comma_sperated_markers = last_line.slice(last_line.index(":") + 1, last_line.size)
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
