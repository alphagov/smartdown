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
            line("True case")
          end
          false_case do
            line("False case")
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
          line("True case")
        end
      }

      it "should resolve the conditional and preserve the 'True case' paragraph block" do
        expect(conditional_resolver.call(node, state)).to eq(expected_node_after_presentation)
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
          line("False case")
        end
      }

      it "should resolve the conditional and preserve the 'False case' paragraph block" do
        expect(conditional_resolver.call(node, state)).to eq(expected_node_after_presentation)
      end
    end
  end
  context "a node with nested conditionals" do
    let(:node) {
      model_builder.node("outcome_no_visa_needed") do
        conditional do
          named_predicate "pred1?"
          true_case do
            line("True case")
          end
          false_case do
            conditional do
              named_predicate "pred2?"
              true_case do
                line("False True case")
              end
            end
          end
        end
      end
    }

    context "first pred is true" do
      let(:state) {
        Smartdown::Engine::State.new(
          current_node: node.name,
          pred1?: true,
          pred2?: "Doesn't matter"
        )
      }

      let(:expected_node_after_presentation) {
        model_builder.node("outcome_no_visa_needed") do
          line("True case")
        end
      }

      it "should resolve the conditional and preserve the 'True case' paragraph block" do
        expect(conditional_resolver.call(node, state)).to eq(expected_node_after_presentation)
      end
    end


    context "first pred is false" do
      context "second pred is true" do
        let(:state) {
          Smartdown::Engine::State.new(
            current_node: node.name,
            pred1?: false,
            pred2?: true
          )
        }

        let(:expected_node_after_presentation) {
          model_builder.node("outcome_no_visa_needed") do
            line("False True case")
          end
        }

        it "should resolve the conditional and preserve the 'True case' paragraph block" do
          expect(conditional_resolver.call(node, state)).to eq(expected_node_after_presentation)
        end
      end

      context "second pred is false" do
        let(:state) {
          Smartdown::Engine::State.new(
            current_node: node.name,
            pred1?: false,
            pred2?: false
          )
        }

        let(:expected_node_after_presentation) {
          model_builder.node("outcome_no_visa_needed") do
          end
        }

        it "should resolve the conditional and resolve no false case to be empty" do
          expect(conditional_resolver.call(node, state)).to eq(expected_node_after_presentation)
        end
      end
    end
  end
end
