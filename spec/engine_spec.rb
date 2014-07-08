require 'smartdown/engine'
require 'smartdown/model'

describe Smartdown::Engine do
  let(:flow) {
    Smartdown::Model.build do
      flow("check-uk-visa") do
        node("check-uk-visa") do
          heading("Check uk visa")
          paragraph("This is the paragraph")
          start_button("what_passport_do_you_have?")
          next_node_rules do
            rule do
              named_predicate("otherwise")
              outcome("what_passport_do_you_have?")
            end
          end
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

      it "is on what_passport_do_you_have?" do
        expect(subject.get(:current_node)).to eq("what_passport_do_you_have?")
      end

      it "has recorded input" do
        expect(subject.get("check-uk-visa")).to eq("yes")
      end
    end

    context "greek passport" do
      let(:responses) { %w{yes greek} }

      it "is on what_passport_do_you_have?" do
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
end
