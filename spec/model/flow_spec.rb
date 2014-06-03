require 'smartdown/model/flow'
require 'smartdown/model/state'
require 'smartdown/model/question/multiple_choice'

describe Smartdown::Model::Flow do
  subject {
    Smartdown::Model::Flow.new("my_name")
  }

  let(:question) {
    Smartdown::Model::Question::MultipleChoice.new("chocolate?", body: "# Do you like chocolate?").tap do |q|
      q.add_choice(:yes, "Yes")
      q.add_choice(:no, "No")
      q.next_node(:sweet)
    end
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

  describe "#add_question" do
    before(:each) {
      subject.add_question(question)
    }

    it "adds a question" do
      expect(subject.questions).to eq [question]
    end

    it "sets the current_node of the start state" do
      expect(subject.start_state).to be_a(Smartdown::Model::State)
      expect(subject.start_state.get(:current_node)).to eq("chocolate?")
    end
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
      expect(question).to receive(:transition).with(subject.start_state, "yes").and_return(new_state)
      expect(subject.process(["yes"])).to eq new_state
    end

    it "processes the given list of responses using the question" do
      subject.process(["maybe"])
    end

  end
end
