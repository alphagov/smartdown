require 'smartdown/errors'
require 'smartdown/engine/transition'
require 'smartdown/engine/state'
require 'smartdown/model'

describe Smartdown::Engine::Transition do
  let(:current_node_name) { "q1" }
  let(:start_state) { Smartdown::Engine::State.new(current_node: current_node_name) }
  let(:input) { "yes" }
  subject(:transition) { described_class.new(start_state, current_node, input, predicate_evaluator: predicate_evaluator) }
  let(:predicate_evaluator) { instance_double("Smartdown::Engine::PredicateEvaluator") }

  context "no next node rules" do
    let(:current_node) {
      Smartdown::Model::Node.new(current_node_name, [])
    }

    describe "#next_node" do
      it "raises IndeterminateNextNode" do
        expect { transition.next_node }.to raise_error(Smartdown::IndeterminateNextNode)
      end
    end
  end

  context "next node rules defined with a simple rule" do
    let(:predicate1) { double("predicate1") }
    let(:outcome_name1) { "o1" }
    let(:predicate2) { double("predicate2") }
    let(:outcome_name2) { "o2" }

    let(:current_node) {
      Smartdown::Model::Node.new(
        current_node_name,
        [
          Smartdown::Model::NextNodeRules.new(
            [
              Smartdown::Model::Rule.new(
                predicate1, outcome_name1
              ),
              Smartdown::Model::Rule.new(
                predicate2, outcome_name2
              )
            ]
          )
        ]
      )
    }

    let(:state_including_input) {
      start_state.put(current_node.name, input)
    }

    describe "#next_node" do
      it "invokes the predicate evaluator with the predicate and state including the input value" do
        expect(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(true)

        transition.next_node
      end

      it "invokes the predicate evaluator for each rule in turn" do
        allow(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(false)
        expect(predicate_evaluator).to receive(:evaluate).with(predicate2, state_including_input).and_return(true)

        transition.next_node
      end

      it "returns the name of the next node" do
        allow(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(false)
        allow(predicate_evaluator).to receive(:evaluate).with(predicate2, state_including_input).and_return(true)

        expect(transition.next_node).to eq(outcome_name2)
      end
    end

    describe "#next_state" do
      before(:each) do
        allow(predicate_evaluator).to receive(:evaluate).and_return(true)
      end

      it "returns a state including a record of responses, path, and new current_node" do
        expected_state = start_state
          .put(:responses, [input])
          .put(:path, [current_node_name])
          .put(:current_node, outcome_name1)
          .put(current_node.name, input)

        expect(transition.next_state).to eq(expected_state)
      end
    end
  end
end
