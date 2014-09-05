require 'smartdown/model/predicate/set_membership'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::SetMembership do
  let(:expected_values) { ["v1", "v2", "v3"] }
  let(:varname) { "my_var" }
  subject(:predicate) { described_class.new(varname, expected_values) }

  describe "#evaluate" do
    context "state missing expected variable" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n") }

      it "raises an UndefinedValue error" do
        expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
      end
    end

    context "state has expected variable with one of the expected values" do
      it "evaluates to true" do
        expected_values.each do |value|
          state = Smartdown::Engine::State.new(current_node: "n", varname => value)
          expect(predicate.evaluate(state)).to eq(true)
        end
      end
    end

    context "state has expected variable with a value not in the list of expected values" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n", varname => "some other value") }

      it "evaluates to false" do
        expect(predicate.evaluate(state)).to eq(false)
      end
    end
  end
end
