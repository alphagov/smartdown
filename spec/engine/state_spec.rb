require 'smartdown/engine/state'

describe Smartdown::Engine::State do
  subject {
    described_class.new(current_node: :start_state)
  }

  it "raises if current_node not given to constructor" do
    expect { described_class.new() }.to raise_error(ArgumentError)
  end

  it "initializes path and responses" do
    expect(subject.get(:responses)).to eq []
    expect(subject.get(:path)).to eq []
  end

  describe "#get" do
    it "raises if a value is undefined" do
      expect { subject.get(:a) }.to raise_error(Smartdown::Engine::UndefinedValue)
    end

    it "is indifferent to symbols and strings" do
      expect(subject.get(:current_node)).to eq(:start_state)
      expect(subject.get("current_node")).to eq(:start_state)
    end
  end

  describe "#keys" do
    it "returns a set of all keys in the state" do
      expect(subject.keys).to eq(Set.new(["current_node", "path", "responses"]))
    end
  end

  describe "#put" do
    it "returns a copy of state and leaves orignal unchanged" do
      new_state = subject.put(:a, 1)
      expect { subject.get(:a) }.to raise_error
      expect(new_state.get(:a)).to eq 1
    end

    it "is indifferent to symbols and strings" do
      s2 = subject.put(:b, 1)
      expect(s2.get(:b)).to eq(1)
      expect(s2.get("b")).to eq(1)
      s3 = subject.put("b", 2)
      expect(s3.get(:b)).to eq(2)
      expect(s3.get("b")).to eq(2)
    end
  end

  context "lambda values" do
    let(:predicate) { double("predicate", call: true) }
    subject(:state) {
      described_class.new(current_node: :start_state, predicate?: predicate)
    }

    describe "#get" do
      it "evaluates lambda with state" do
        expect(predicate).to receive(:call).with(state).and_return(true)
        expect(state.get(:predicate?)).to eq(true)
      end

      it "caches the result of evaluating the lambda" do
        expect(predicate).to receive(:call).once
        state.get(:predicate?)
        state.get(:predicate?)
      end
    end

    describe "#==" do
      let(:l1) { ->(state) { true } }
      let(:l2) { ->(state) { true } }

      let(:state_with_l1a) { described_class.new(current_node: "red", pred: l1)}
      let(:state_with_l1b) { described_class.new(current_node: "red", pred: l1)}
      let(:state_with_l2) { described_class.new(current_node: "red", pred: l2)}

      it "is equal if identical lambdas" do
        expect(state_with_l1a).to eq(state_with_l1b)
      end

      it "is not equal if different lambdas" do
        expect(state_with_l1a).not_to eq(state_with_l2)
      end
    end
  end

  describe "#==" do
    let(:s1) { described_class.new(current_node: "red") }
    let(:s2) { described_class.new(current_node: "red") }
    let(:s3) { described_class.new(current_node: "green") }
    let(:s4) { described_class.new(current_node: "red", a: 1) }

    it "is true if two states have the same keys and values" do
      expect(s1).to eq(s2)
    end

    it "is false if two states have the same keys with different values" do
      expect(s1).not_to eq(s3)
    end

    it "is false if one state is a subset of the other" do
      expect(s1).not_to eq(s4)
    end
  end
end
