require 'smartdown/api/flow'

describe Smartdown::Api::Flow do

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  let(:input) { Smartdown::Parser::DirectoryInput.new(fixture("animal-example-simple")) }
  subject(:flow) { Smartdown::Api::Flow.new(input) }

  it "has two scenario_sets" do
    expect(flow.scenario_sets.size).to eq(2)
  end

  it "has scenario_set names" do
    expect(flow.scenario_sets.map(&:name)).to match_array(["lions", "tigers_and_cats"])
  end

  it "has scenarios with description, questions and outcome" do
    tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
    expect(tigers_and_cats_scenario_set.scenarios.size).to eq(1)
    expect(tigers_and_cats_scenario_set.scenarios.first.description).to eq("User has a cat")
    expect(tigers_and_cats_scenario_set.scenarios.first.questions.size).to eq(1)
    expect(tigers_and_cats_scenario_set.scenarios.first.outcome).to eq("outcome_safe_pet")
  end

  it "has scenario questions with name and answer" do
    tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
    tigers_and_cats_scenario = tigers_and_cats_scenario_set.scenarios.first
    expect(tigers_and_cats_scenario.questions.first.name).to eq("question_1")
    expect(tigers_and_cats_scenario.questions.first.answer).to eq("cat")
  end

end


