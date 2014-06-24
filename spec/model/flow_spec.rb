require 'smartdown/model/flow'
require 'smartdown/model/state'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/question/multiple_choice'

describe Smartdown::Model::Flow do
  let(:coversheet) {
    double("coversheet", name: "my_name")
  }

  subject {
    Smartdown::Model::Flow.new(coversheet)
  }

  let(:h1) { {h1: "Do you like chocolate?"} }

  let(:node_name) { "chocolate?" }
  let(:question) {
    Smartdown::Model::Question::MultipleChoice.new(node_name, {yes: "Yes", no: "No"})
  }
  let(:next_node_rules) {
    Smartdown::Model::NextNodeRules.new(node_name)
  }
  let(:node) {
    Smartdown::Model::Node.new(node_name, body_blocks: [h1, question, next_node_rules])
  }

  it "has a name" do
    expect(subject.name).to eq "my_name"
  end

  it "has a list of questions" do
    expect(subject.questions).to eq []
  end

  it "has an invalid start_state if there are no questions" do
    expect { subject.start_state }.to raise_error
  end

  describe "#node" do
    it "fetches the named node" do
      subject.add_question(question)
      expect(subject.node(question.name)).to eq question
    end

    it "raises if node not found" do
      expect { subject.node("undefined node") }.to raise_error
    end
  end

  describe "#process" do
    before(:each) {
      subject.add_question(question)
    }

    it "processes the given list of responses using the question" do
      new_state = double("new state")
      expect(next_node_rules).to receive(:transition).with(subject.start_state, "yes").and_return(new_state)
      expect(subject.process(["yes"])).to eq new_state
    end

    it "processes the given list of responses using the question" do
      subject.process(["maybe"])
    end

  end
end
