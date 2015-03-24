require 'smartdown'
require 'smartdown/parser/scenario_sets_interpreter'

describe Smartdown::Parser::ScenarioSetsInterpreter do
  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  let(:input) { Smartdown::Parser::DirectoryInput.new(fixture("animal-example-simple")) }
  subject(:scenario_sets) { described_class.new(input).interpret }


  context "flow with one question per page" do
    it "has two scenario_sets" do
      expect(scenario_sets.size).to eq(2)
    end

    it "has scenario_set names" do
      expect(scenario_sets.map(&:name)).to match_array(["lions", "tigers_and_cats"])
    end

    it "has scenarios with description, questions, markers and outcome" do
      tigers_and_cats_scenario_set = scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
      expect(tigers_and_cats_scenario_set.scenarios.size).to eq(1)
      expect(tigers_and_cats_scenario_set.scenarios.first.description).to eq("User has a cat;And cats are amazing")
      expect(tigers_and_cats_scenario_set.scenarios.first.question_groups.size).to eq(1)
      expect(tigers_and_cats_scenario_set.scenarios.first.outcome).to eq("outcome_safe_pet")
      expect(tigers_and_cats_scenario_set.scenarios.first.markers).to eq(['is_a_safe_pet', 'safe_pets_are_cool'])
    end

    it "has scenario questions with name and answer" do
      tigers_and_cats_scenario_set = scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
      tigers_and_cats_scenario = tigers_and_cats_scenario_set.scenarios.first
      expect(tigers_and_cats_scenario.question_groups.first.first.name).to eq("question_1")
      expect(tigers_and_cats_scenario.question_groups.first.first.answer).to eq("cat")
    end
  end
end