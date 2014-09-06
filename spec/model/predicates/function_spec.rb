require 'smartdown/model/predicate/function'
require 'smartdown/engine/state'

describe Smartdown::Model::Predicate::Function do
  let(:function_name) { "my_function" }
  subject(:predicate) { described_class.new(function_name, []) }

  describe "#evaluate" do
    context "state missing expected function definition" do
      let(:state) { Smartdown::Engine::State.new(current_node: "n") }

      it "raises an UndefinedValue error" do
        expect { predicate.evaluate(state) }.to raise_error(Smartdown::Engine::UndefinedValue)
      end
    end

    context "with no arguments" do
      let(:function_return) { "hello" }
      let(:my_function) { ->() { "hello" } }
      let(:state) { Smartdown::Engine::State.new(current_node: "n", function_name => my_function) }

      it "gets the return value of the function" do
        expect(predicate.evaluate(state)).to eq(function_return)
      end
    end

    context "with arguments" do
      let(:my_function) { ->(x) { x * 100 } }
      subject(:predicate) { described_class.new(function_name, ["number"]) }
      let(:state) { Smartdown::Engine::State.new(current_node: "n", "number" => 3, function_name => my_function) }

      it "gets the return value of the function" do
        expect(predicate.evaluate(state)).to eq(300)
      end
    end

    context "with many arguments" do
      let(:function_return) { "hello" }
      let(:my_function) { ->(name, age) { "Hi #{name}, you were #{age-20}, 20 years ago" } }
      subject(:predicate) { described_class.new(function_name, ["name", "age"]) }
      let(:state) { Smartdown::Engine::State.new(current_node: "n", "name" => "David", "age" => 30, function_name => my_function) }

      it "gets the return value of the function" do
        expect(predicate.evaluate(state)).to eq("Hi David, you were 10, 20 years ago")
      end
    end

    context "with nested functions" do
      # nesting looks like: function_1(function_2(5))
      let(:function_1) { ->(x) { x - 1 } }
      let(:function_2) { ->(x) { x * 100 } }
      subject(:predicate) {
        described_class.new("function_1", [
          described_class.new("function_2", ['number'])
        ])
      }

      let(:state) { Smartdown::Engine::State.new(
        current_node: "n",
        "function_1" => function_1,
        "function_2" => function_2,
        "number" => 5
      ) }

      it "gets the return value of the function" do
        expect(predicate.evaluate(state)).to eq(499)
      end
    end
  end

  describe "#humanize" do
    context "with no arguments" do
      subject(:predicate) { described_class.new(function_name, []) }

      it { expect(predicate.humanize).to eq("my_function()") }
    end

    context "with some arguments" do
      let(:function_name) { "my_function" }
      subject(:predicate) { described_class.new(function_name, ['foo', 'bar']) }

      it { expect(predicate.humanize).to eq("my_function(foo bar)") }
    end
  end
end
