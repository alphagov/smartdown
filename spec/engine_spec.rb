require 'smartdown/engine'

xdescribe Smartdown::Engine do

  describe "#process" do
    it "processes the given list of responses using the next_node_rules" do
      new_state = instance_double("Smartdown::Model::State")
      expect(next_node_rules).to receive(:transition).with(subject.start_state, "yes").and_return(new_state)
      expect(subject.process(["yes"])).to eq new_state
    end

    it "processes the given list of responses using the question" do
      subject.process(["maybe"])
    end
  end

  describe "#transition" do
    let(:current_node_name) { "a_or_b?" }
    let(:state) { Smartdown::Model::State.new(current_node: current_node_name) }
    let(:input) { "yes" }
    subject { described_class.new(current_node_name) }

    describe "no next node defined" do
      it "raises" do
        expect { subject.transition(state, input) }.to raise_error(Smartdown::IndeterminateNextNode)
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
