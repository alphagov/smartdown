require 'smartdown/engine'

describe Smartdown::Engine do
  let(:flow) {
    build_flow("check-uk-visa") do
      node("check-uk-visa") do
        heading("Check uk visa")
        paragraph("This is the paragraph")
        start_button("what_passport_do_you_have?")
      end

      node("what_passport_do_you_have?") do
        heading("What passport do you have?")
        multiple_choice(
          greek: "Greek",
          british: "British",
          usa: "USA"
        )
        next_node_rules do
          rule do
            named_predicate("eea_passport?")
            outcome("outcome_no_visa_needed")
          end
        end
      end

      node("outcome_no_visa_needed") do
        conditional do
          named_predicate "pred?"
          true_case do
            paragraph("True case")
          end
          false_case do
            paragraph("False case")
          end
        end
      end

      node("outcome_with_interpolation") do
        paragraph("The answer is %{interpolated_variable}")
      end
    end
  }

  subject(:engine) { Smartdown::Engine.new(flow) }
  let(:start_state) {
    engine.default_start_state
      .put(:eea_passport?, ->(state) {
        %w{greek british}.include?(state.get(:what_passport_do_you_have?))
      })
      .put(:otherwise, true)
  }

  describe "#process" do
    subject { engine.process(responses, start_state) }

    context "start button response only" do
      let(:responses) { %w{yes} }

      it { should be_a(Smartdown::Engine::State) }

      it "current_node of 'what_passport_do_you_have?'" do
        expect(subject.get(:current_node)).to eq("what_passport_do_you_have?")
      end

      it "input recorded in state variable corresponding to node name" do
        expect(subject.get("check-uk-visa")).to eq("yes")
      end
    end

    context "greek passport" do
      let(:responses) { %w{yes greek} }

      it "is on outcome_no_visa_needed" do
        expect(subject.get(:current_node)).to eq("outcome_no_visa_needed")
      end

      it "has recorded input" do
        expect(subject.get("what_passport_do_you_have?")).to eq("greek")
      end
    end

    context "USA passport" do
      let(:responses) { %w{yes usa} }

      it "raises IndeterminateNextNode error" do
        expect { subject }.to raise_error(Smartdown::Engine::IndeterminateNextNode)
      end
    end
  end

  describe "#evaluate_node" do
    context "conditional resolution" do
      let(:current_state) {
        start_state
          .put(:current_node, "outcome_no_visa_needed")
          .put(:pred?, true)
      }

      let(:expected_node_after_conditional_resolution) {
        model_builder.node("outcome_no_visa_needed") do
          paragraph("True case")
        end
      }

      it "evaluates the current node of the given state, resolving any conditionals" do
        expect(engine.evaluate_node(current_state)).to eq(expected_node_after_conditional_resolution)
      end
    end

    context "interpolation" do
      let(:current_state) {
        start_state
          .put(:current_node, "outcome_with_interpolation")
          .put(:interpolated_variable, "42")
      }

      let(:expected_node_after_conditional_resolution) {
        model_builder.node("outcome_with_interpolation") do
          paragraph("The answer is 42")
        end
      }

      it "evaluates the current node of the given state, resolving any conditionals" do
        expect(engine.evaluate_node(current_state)).to eq(expected_node_after_conditional_resolution)
      end
    end
  end

end
