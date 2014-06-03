require 'smartdown/model/question/multiple_choice'
require 'smartdown/model/state'
require 'model/question/shared_examples'

describe Smartdown::Model::Question::MultipleChoice do
  it_behaves_like "a question"

  let(:choices) {
    {
      "a" => "First one",
      "b" => "Second one"
    }
  }

  subject {
    Smartdown::Model::Question::MultipleChoice.new("a_or_b?", body: "my body", choices: choices)
  }

  it "#choices returns the list of choices" do
    expect(subject.choices).to eq choices
  end

  it "#add_choice adds choices" do
    subject.add_choice(:yes, "Yes")
    expect(subject.choices).to have_key("yes")
    expect(subject.choices["yes"]).to eq "Yes"
  end

  describe "#transition" do
    let(:state) { Smartdown::Model::State.new(current_node: subject.name) }
    let(:input) { "yes" }

    describe "no next node defined" do
      it "raises" do
        expect { subject.transition(state, input) }.to raise_error(Smartdown::Model::IndeterminateNextNode)
      end
    end

    describe "illegal input" do
      it "raises" do
        expect { subject.transition(state, input) }.to raise_error(Smartdown::Model::IndeterminateNextNode)
      end
    end

    describe "next node defined" do
      before(:each) {
        subject.next_node(:outcome_1)
      }

      it "returns a new state with current_node set to the new node" do
        subject.next_node(:outcome_1)
        new_state = subject.transition(state, input)
        expect(new_state.get(:current_node)).to eq :outcome_1
      end

      it "stores the input in new state using the name of the node" do
        subject.next_node(:outcome_1)
        new_state = subject.transition(state, input)
        expect(new_state.get(:a_or_b)).to eq input
      end

      it "stores path in new state" do
        subject.next_node(:outcome_1)
        new_state = subject.transition(state, input)
        expect(new_state.get(:path)).to eq [state.get(:current_node)]
      end

      it "stores responses in new state" do
        subject.next_node(:outcome_1)
        new_state = subject.transition(state, input)
        expect(new_state.get(:responses)).to eq [input]
      end
    end
  end
end
