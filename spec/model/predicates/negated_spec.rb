require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/negated'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::Negated do
  subject(:negated_predicate) { described_class.new(inner_predicate) }
  let(:inner_predicate_name) { "my_pred?" }
  let(:inner_predicate) { Smartdown::Model::Predicate::Named.new inner_predicate_name }

  describe "#evaluate" do
    context "state has predicate definition" do
      let(:state) {
        Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true )
      }

      it "returns the negation of the inner predicate" do
        expect(negated_predicate.evaluate(state)).to eq(false)
      end
    end
  end

  describe "#humanize" do
    it "prepends the inner predicate's humanize with NOT" do
      expect(negated_predicate.humanize).to eq("NOT my_pred?")
    end
  end
end
