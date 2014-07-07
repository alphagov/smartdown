require 'smartdown/model/state'

describe Smartdown::Model::State do
  subject {
    Smartdown::Model::State.new(current_node: :start_state)
  }

  it "raises if current_node not given to constructor" do
    expect { Smartdown::Model::State.new() }.to raise_error(ArgumentError)
  end

  it "initializes path and responses" do
    expect(subject.get(:responses)).to eq []
    expect(subject.get(:path)).to eq []
  end

  describe "#get" do
    it "raises if a value is undefined" do
      expect { subject.get(:a) }.to raise_error(Smartdown::Model::UndefinedValue)
    end

    it "by string or symbol" do
      expect(subject.get(:current_node)).to eq(:start_state)
      expect(subject.get("current_node")).to eq(:start_state)
    end
  end

  describe "#put" do
    it "returns a copy of state and leaves orignal unchanged" do
      new_state = subject.put(:a, 1)
      expect { subject.get(:a) }.to raise_error
      expect(new_state.get(:a)).to eq 1
    end

    it "by string or symbol" do
      s2 = subject.put(:b, 1)
      expect(s2.get(:b)).to eq(1)
      expect(s2.get("b")).to eq(1)
      s3 = subject.put("b", 2)
      expect(s3.get(:b)).to eq(2)
      expect(s3.get("b")).to eq(2)
    end
  end
end
