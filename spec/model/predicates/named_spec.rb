require 'smartdown/model/predicate/named'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::Named do
  let(:predicate_name) { "my_pred?" }
  subject(:predicate) { described_class.new(predicate_name) }

  describe "#evaluate" do
    context "state missing predicate definition" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n") }

      it "raises an UndefinedValue error" do
        expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
      end
    end

    context "state has predicate definition" do
      let(:state) {
        Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true )
      }

      it "fetches the predicate value from the state" do
        expect(predicate.evaluate(state)).to eq(true)
      end
    end
  end
end
