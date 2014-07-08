require 'smartdown/engine/predicate_evaluator'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'
require 'smartdown/model/predicate/named'
require 'smartdown/engine/state'

describe Smartdown::Engine::PredicateEvaluator do
  subject(:evalutator) { described_class.new }

  context "equality predicate" do
    let(:predicate) { Smartdown::Model::Predicate::Equality.new("my_var", "some value") }

    describe "#evaluate" do
      context "state missing expected variable" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n") }

        it "raises an UndefinedValue error" do
          expect { evalutator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has expected variable with same value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some value") }

        it "evalutes to true" do
          expect(evalutator.evaluate(predicate, state)).to eq(true)
        end
      end

      context "state has expected variable with a different value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "some other value") }

        it "evalutes to false" do
          expect(evalutator.evaluate(predicate, state)).to eq(false)
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
          expect { evalutator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has expected variable with one of the expected values" do
        it "evalutes to true" do
          expected_values.each do |value|
            state = Smartdown::Engine::State.new(current_node: "n", varname => value)
            expect(evalutator.evaluate(predicate, state)).to eq(true)
          end
        end
      end

      context "state has expected variable with a value not in the list of expected values" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", varname => "some other value") }

        it "evalutes to false" do
          expect(evalutator.evaluate(predicate, state)).to eq(false)
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
          expect { evalutator.evaluate(predicate, state) }.to raise_error(Smartdown::Engine::UndefinedValue)
        end
      end

      context "state has predicate definition" do
        let(:state) {
          Smartdown::Engine::State.new("current_node" => "n", "my_pred?" => true )
        }

        it "fetches the predicate value from the state" do
          expect(evalutator.evaluate(predicate, state)).to eq(true)
        end
      end
    end
  end

end
