require "smartdown/model/scenarios/scenario_set"
require "smartdown/parser/scenario_set_interpreter"

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
        Smartdown::Model::Scenarios::ScenarioSet.new(
          scenario_set.name,
          scenario_set.read.split("\n\n").map do |scenario_string|
            ScenarioSetInterpreter.new(scenario_string).scenario
          end
        )
      end
    end
  end
end
