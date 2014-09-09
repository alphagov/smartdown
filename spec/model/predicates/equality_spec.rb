require 'smartdown/model/predicate/equality'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::Equality do
  subject(:predicate) { described_class.new("my_var", "some value") }

  describe "#evaluate" do
    context "state missing expected variable" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n") }

      it "raises an UndefinedValue error" do
        expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
      end
    end

    context "state has expected variable with same value" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some value") }

      it "evaluates to true" do
        expect(predicate.evaluate(state)).to eq(true)
      end
    end

    context "state has expected variable with a different value" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some other value") }

      it "evaluates to false" do
        expect(predicate.evaluate(state)).to eq(false)
      end
    end
  end

  describe "#humanize" do
    it { expect(predicate.humanize).to eq("my_var == 'some value'") }
  end
end
