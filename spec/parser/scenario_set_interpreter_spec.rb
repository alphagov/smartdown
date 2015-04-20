require 'smartdown/parser/scenario_set_interpreter'

describe Smartdown::Parser::ScenarioSetInterpreter do
  let(:scenario) { File.open(File.dirname(__FILE__) + "/../fixtures/acceptance/animal-example-simple/scenarios/tigers_and_cats.txt", "rb").read }
  subject { described_class.new(scenario) }

  describe "#description" do
    it { expect(subject.description).to eq("User has a cat;And cats are amazing") }
  end

  describe "#question_groups" do
    it { expect(subject.question_groups).to eq([ [ Smartdown::Model::Scenarios::Question.new("question_1", "cat") ] ]) }
  end

  describe "#outcome" do
    it { expect(subject.outcome).to eq("outcome_safe_pet") }
  end

  describe "#markers" do
    it { expect(subject.markers).to eq(["is_a_safe_pet"]) }
  end

  describe "#exact_markers" do
    it { expect(subject.exact_markers).to eq(["is_a_safe_pet", "safe_pets_are_cool"]) }
  end
end