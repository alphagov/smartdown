module Smartdown
  module Parser
    class ScenarioSetsInterpreter

      def initialize(smartdown_input)
        @smartdown_input = smartdown_input
      end

      def interpret
        @smartdown_input.scenario_sets.map { |scenario_set| interpret_scenario_set(scenario_set) }
      end

    private
      def interpret_scenario_set(scenario_set)
        OpenStruct.new(
          :name => scenario_set.name,
          :scenarios => scenario_set.read.split("\n\n").map { |scenario_string| interpret_scenario(scenario_string) }
        )
      end

      def interpret_scenario(scenario_string)
        scenario_lines = scenario_string.split("\n")
        if scenario_lines.first.start_with?("#")
          description = scenario_lines.first[1..-1].strip
          scenario_lines = scenario_lines[1..-1]
        end
        outcome = scenario_lines.last
        question_pages = group_questions_by_page(scenario_lines[0..-2])
        question_groups = question_pages.map { |question_page| interpret_question_page(question_page) }
        OpenStruct.new(
          :description => description,
          :question_groups => question_groups,
          :outcome => outcome,
        )
      end

      def group_questions_by_page(scenario_lines)
        result = []
        scenario_lines.each do |scenario_line|
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
        OpenStruct.new(
          :name => name,
          :answer => answer,
        )
      end
    end
  end
end
