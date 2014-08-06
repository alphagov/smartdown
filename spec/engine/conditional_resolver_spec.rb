require 'smartdown/engine/conditional_resolver'
require 'smartdown/engine/state'

describe Smartdown::Engine::ConditionalResolver do
  subject(:conditional_resolver) { described_class.new }

  context "a node with a conditional" do
    let(:node) {
      model_builder.node("outcome_no_visa_needed") do
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
    }

    context "pred is true" do
      let(:state) {
        Smartdown::Engine::State.new(
          current_node: node.name,
          pred?: true
        )
      }

      let(:expected_node_after_presentation) {
        model_builder.node("outcome_no_visa_needed") do
          paragraph("True case")
        end
      }

      it "should resolve the conditional and preserve the 'True case' paragraph block" do
        expect(conditional_resolver.present(node, state)).to eq(expected_node_after_presentation)
      end
    end

    context "pred is false" do
      let(:state) {
        Smartdown::Engine::State.new(
          current_node: node.name,
          pred?: false
        )
      }

      let(:expected_node_after_presentation) {
        model_builder.node("outcome_no_visa_needed") do
          paragraph("False case")
        end
      }

      it "should resolve the conditional and preserve the 'False case' paragraph block" do
        expect(conditional_resolver.present(node, state)).to eq(expected_node_after_presentation)
      end
    end
  end
end
