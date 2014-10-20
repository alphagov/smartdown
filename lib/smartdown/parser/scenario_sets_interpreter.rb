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
          description = scenario_lines.first[1..-1]
          scenario_lines = scenario_lines[1..-1]
        end
        outcome = scenario_lines.last
        questions = scenario_lines[0..-2].map { |question_line| interpret_question(question_line) }
        OpenStruct.new(
          :description => description,
          :questions => questions,
          :outcome => outcome,
        )
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
