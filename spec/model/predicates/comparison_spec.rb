require 'smartdown/model/predicate/comparison/greater_or_equal'
require 'smartdown/model/predicate/comparison/greater'
require 'smartdown/model/predicate/comparison/less_or_equal'
require 'smartdown/model/predicate/comparison/less'
require 'smartdown/engine/state'

describe "comparison predicates" do
  context "comparison predicates with integers" do
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
            expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
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
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
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
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
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
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
          end
        end
      end
    end
  end

  context "comparison predicates with dates" do
    let(:greater_predicate) { Smartdown::Model::Predicate::Comparison::Greater.new("my_var", "2014-1-31") }
    let(:greater_or_equal_predicate) { Smartdown::Model::Predicate::Comparison::GreaterOrEqual.new("my_var", "2014-1-31") }
    let(:less_predicate) { Smartdown::Model::Predicate::Comparison::Less.new("my_var", "2014-1-31") }
    let(:less_or_equal_predicate) { Smartdown::Model::Predicate::Comparison::LessOrEqual.new("my_var", "2014-1-31") }
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
            expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
          end
        end
      end

      context "state has lower value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "2014-1-30") }
        let(:results) { {
            :greater => false,
            :greater_or_equal => false,
            :less => true,
            :less_or_equal => true
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
          end
        end
      end

      context "state has identical value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "2014-1-31") }
        let(:results) { {
            :greater => false,
            :greater_or_equal => true,
            :less => false,
            :less_or_equal => true
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
          end
        end
      end

      context "state has higher value" do
        let(:state) { Smartdown::Engine::State.new(current_node: "n", my_var: "2014-2-1") }
        let(:results) { {
            :greater => true,
            :greater_or_equal => true,
            :less => false,
            :less_or_equal => false
        } }
        it "evaluates correctly" do
          predicates.each do |predicate_key, predicate|
            expect(predicate.evaluate(state)).to eq(results[predicate_key])
          end
        end
      end
    end
  end
end
