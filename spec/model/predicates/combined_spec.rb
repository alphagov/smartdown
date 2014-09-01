require 'smartdown/model/predicate/combined'
require 'smartdown/model/predicate/combined'
require 'smartdown/model/predicate/named'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::Combined do
  let(:predicate_1) { Smartdown::Model::Predicate::Named.new("my_pred?") }
  let(:predicate_2) { Smartdown::Model::Predicate::Named.new("my_other_pred?") }
  subject(:predicate) { described_class.new([predicate_1, predicate_2])}

  describe "#evaluate" do

    context "both states are true" do
      let(:state) {
        Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true, "my_other_pred?" => true )
      }

      it "evaluates as true" do
        expect(predicate.evaluate(state)).to eq(true)
      end
    end

    context "both states are false" do
      let(:state) {
        Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => false, "my_other_pred?" => false )
      }

      it "evaluates as false" do
        expect(predicate.evaluate(state)).to eq(false)
      end
    end

    context "one of the states is false" do
      let(:state) {
        Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true, "my_other_pred?" => false )
      }

      it "evaluates as false" do
        expect(predicate.evaluate(state)).to eq(false)
      end
    end
  end

  describe "#humanize" do
    it { expect(predicate.humanize).to eq("(my_pred? AND my_other_pred?)") }
  end
end
