require 'smartdown/engine/predicate_evaluator'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'
require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/combined'
require 'smartdown/model/predicate/comparison/greater_or_equal'
require 'smartdown/model/predicate/comparison/greater'
require 'smartdown/model/predicate/comparison/less_or_equal'
require 'smartdown/model/predicate/comparison/less'
require 'smartdown/engine/state'

describe Smartdown::Engine::PredicateEvaluator do
  subject(:evaluator) { described_class.new }

  context "equality predicate" do
    let(:predicate) { Smartdown::Model::Predicate::Equality.new("my_var", "some value") }

    describe "#evaluate" do
      context "state missing expected variable" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n") }

        it "raises an UndefinedValue error" do
          expect { evaluator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has expected variable with same value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some value") }

        it "evaluates to true" do
          expect(evaluator.evaluate(predicate, state)).to eq(true)
        end
      end

      context "state has expected variable with a different value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some other value") }

        it "evaluates to false" do
          expect(evaluator.evaluate(predicate, state)).to eq(false)
        end
      end
    end
  end

  context "set membership predicate" do
    let(:expected_values) { ["v1", "v2", "v3"] }
    let(:varname) { "my_var" }
    let(:predicate) { Smartdown::Model::Predicate::SetMembership.new(varname, expected_values) }

    describe "#evaluate" do
      context "state missing expected variable" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n") }

        it "raises an UndefinedValue error" do
          expect { evaluator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has expected variable with one of the expected values" do
        it "evaluates to true" do
          expected_values.each do |value|
            state = Smartdown::Engine::State.new(current_node: "n", varname => value)
            expect(evaluator.evaluate(predicate, state)).to eq(true)
          end
        end
      end

      context "state has expected variable with a value not in the list of expected values" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", varname => "some other value") }

        it "evaluates to false" do
          expect(evaluator.evaluate(predicate, state)).to eq(false)
        end
      end
    end
  end

  context "named predicate" do
    let(:predicate_name) { "my_pred?" }
    let(:predicate) { Smartdown::Model::Predicate::Named.new(predicate_name) }

    describe "#evaluate" do
      context "state missing predicate definition" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n") }

        it "raises an UndefinedValue error" do
          expect { evaluator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has predicate definition" do
        let(:state) {
          Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true )
        }

        it "fetches the predicate value from the state" do
          expect(evaluator.evaluate(predicate, state)).to eq(true)
        end
      end
    end
  end

  context "combined predicate" do
    let(:predicate_name) { "my_pred?" }
    let(:predicate_name_2) { "my_other_pred?" }
    let(:predicate) { Smartdown::Model::Predicate::Named.new(predicate_name) }
    let(:predicate_2) { Smartdown::Model::Predicate::Named.new(predicate_name_2) }
    let(:combined_predicate) { Smartdown::Model::Predicate::Combined.new([predicate, predicate_2])}

    describe "#evaluate" do

      context "both states are true" do
        let(:state) {
          Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true, "my_other_pred?" => true )
        }

        it "evaluates as true" do
          expect(evalutator.evaluate(combined_predicate, state)).to eq(true)
        end
      end

      context "both states are false" do
        let(:state) {
          Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => false, "my_other_pred?" => false )
        }

        it "evaluates as false" do
          expect(evalutator.evaluate(combined_predicate, state)).to eq(false)
        end
      end

      context "one of the states is false" do
        let(:state) {
          Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true, "my_other_pred?" => false )
        }

        it "evaluates as false" do
          expect(evalutator.evaluate(combined_predicate, state)).to eq(false)
        end
      end
    end

  end

  context "comparison predicates" do
    let(:greater_predicate) { Smartdown::Model::Predicate::Comparison::Greater.new("my_var", "5") }
    let(:greater_or_equal_predicate) { Smartdown::Model::Predicate::Comparison::GreaterOrEqual.new("my_var", "5") }
    let(:less_predicate) { Smartdown::Model::Predicate::Comparison::Less.new("my_var", "5") }
    let(:less_or_equal_predicate) { Smartdown::Model::Predicate::Comparison::LessOrEqual.new("my_var", "5") }
    let(:predicates) { {
      :greater => greater_predicate,
      :greater_or_equal => greater_or_equal_predicate,
      :less => less_predicate,
      :less_or_equal => less_or_equal_predicate
    } }

    describe "#evaluate" do
      context "state missing expected variable" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n") }

        it "raises an UndefinedValue error" do
          predicates.values.each do |predicate|
            expect { evaluator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
          end
        end
      end

      context "state has lower value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "4") }
        let(:results) { {
          :greater => false,
          :greater_or_equal => false,
          :less => true,
          :less_or_equal => true
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(evaluator.evaluate(predicate, state)).to eq(results[predicate_key])
          end
        end
      end

      context "state has identical value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "5") }
        let(:results) { {
            :greater => false,
            :greater_or_equal => true,
            :less => false,
            :less_or_equal => true
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(evaluator.evaluate(predicate, state)).to eq(results[predicate_key])
          end
        end
      end

      context "state has higher value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "6") }
        let(:results) { {
            :greater => true,
            :greater_or_equal => true,
            :less => false,
            :less_or_equal => false
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(evaluator.evaluate(predicate, state)).to eq(results[predicate_key])
          end
        end
      end
    end
  end
end
