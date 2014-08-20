require 'smartdown/engine/transition'
require 'smartdown/engine/state'
require 'smartdown/model/rule'
require 'smartdown/model/nested_rule'

describe Smartdown::Engine::Transition do
  let(:current_node_name) { "q1" }
  let(:start_state) { Smartdown::Engine::State.new(current_node: current_node_name) }
  let(:input) { "yes" }
  let(:input_array) { [input] }
  subject(:transition) { described_class.new(start_state, current_node, input_array, predicate_evaluator: predicate_evaluator) }
  let(:predicate_evaluator) { instance_double("Smartdown::Engine::PredicateEvaluator", evaluate: true) }
  let(:state_including_input) {
    start_state.put(current_node.name, input_array)
  }

  context "no next node rules" do
    let(:current_node) {
      Smartdown::Model::Node.new(current_node_name, [])
    }

    describe "#next_node" do
      it "raises IndeterminateNextNode" do
        expect { transition.next_node }.to raise_error(Smartdown::Engine::IndeterminateNextNode)
      end
    end
  end

  context "no next node rules, but start button" do
    let(:current_node) {
      Smartdown::Model::Node.new(current_node_name, [
        Smartdown::Model::Element::StartButton.new("first_question")
      ])
    }

    describe "#next_node" do
      it "take the next node from the start button" do
        expect(transition.next_node).to eq("first_question")
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
      it "returns a state including a record of responses, path, and new current_node" do
        expected_state = start_state
          .put(:responses, [input])
          .put(:path, [current_node_name])
          .put(:current_node, outcome_name1)
          .put(current_node.name, input_array)

        expect(transition.next_state).to eq(expected_state)
      end
    end
  end

  context "next node rules defined with nested rule" do
    let(:predicate1) { double("predicate1") }
    let(:predicate2) { double("predicate2") }
    let(:predicate3) { double("predicate3") }
    let(:outcome_name1) { "o1" }
    let(:outcome_name2) { "o2" }

    let(:current_node) {
      Smartdown::Model::Node.new(
        current_node_name,
        [
          Smartdown::Model::NextNodeRules.new(
            [
              Smartdown::Model::NestedRule.new(
                predicate1, [
                  Smartdown::Model::Rule.new(
                    predicate2, outcome_name1
                  ),
                  Smartdown::Model::Rule.new(
                    predicate3, outcome_name2
                  )
                ]
              )
            ]
          )
        ]
      )
    }

    describe "#next_node" do
      context "p1 false" do
        it "invokes the predicate evaluator with each predicate in turn" do
          expect(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(false)

          expect { transition.next_node }.to raise_error(Smartdown::Engine::IndeterminateNextNode)
        end
      end

      context "p1 and p2 true" do
        it "invokes the predicate evaluator with each predicate in turn" do
          allow(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(true)
          expect(predicate_evaluator).to receive(:evaluate).with(predicate2, state_including_input).and_return(true)

          expect(transition.next_node).to eq(outcome_name1)
        end
      end

      context "p1 true, p2 false, p3 true" do
        it "invokes the predicate evaluator with each predicate in turn" do
          allow(predicate_evaluator).to receive(:evaluate).with(predicate1, state_including_input).and_return(true)
          allow(predicate_evaluator).to receive(:evaluate).with(predicate2, state_including_input).and_return(false)
          expect(predicate_evaluator).to receive(:evaluate).with(predicate3, state_including_input).and_return(true)

          expect(transition.next_node).to eq(outcome_name2)
        end
      end
    end
  end

  context "next node rules and a named question" do
    let(:question_name) { "my_question" }

    let(:current_node) {
      Smartdown::Model::Node.new(
        current_node_name,
        [
          Smartdown::Model::Element::Question::MultipleChoice.new(question_name, {"a" => "Apple"}),
          Smartdown::Model::NextNodeRules.new(
            [Smartdown::Model::Rule.new(double("predicate1"), "o1")]
          )
        ]
      )
    }

    describe "#next_state" do
      it "assigns the input value to a variable matching the question name" do
        expect(transition.next_state.get(question_name)).to eq(input)
      end
    end

  end

end
