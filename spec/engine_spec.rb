require 'smartdown/engine'

describe Smartdown::Engine do

  subject(:engine) { Smartdown::Engine.new(flow) }
  let(:start_state) {
    engine.build_start_state
      .put(:otherwise, true)
  }

  let(:flow) {
    build_flow("check-uk-visa") do
      node("check-uk-visa") do
        heading("Check uk visa")
        line("This is the paragraph")
        start_button("passport_question")
      end

      node("passport_question") do
        heading("What passport do you have?")
        multiple_choice(
            "what_passport_do_you_have?",
            {
                greek: "Greek",
                british: "British",
                usa: "USA"
            },
            "passport_type?"
        )
        next_node_rules do
          rule do
            set_membership_predicate("what_passport_do_you_have?", ["greek", "british"])
            outcome("outcome_no_visa_needed")
          end
        end
      end

      node("outcome_no_visa_needed") do
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

      node("outcome_with_interpolation") do
        line("The answer is %{interpolated_variable}")
      end
    end
  }
  let(:two_questions_per_page_flow) {
    build_flow("check-uk-visa") do
      node("check-uk-visa") do
        heading("Check uk visa")
        line("This is the paragraph")
        start_button("passport_question")
      end

      node("passport_question") do
        heading("What passport do you have?")
        multiple_choice(
            "what_passport_do_you_have?",
            {
                greek: "Greek",
                british: "British",
                usa: "USA"
            }
        )
        heading("What country are you going to?")
        multiple_choice(
            "what_country_are_you_going_to?",
            {
                usa: "USA",
                narnia: "Narnia"
            }
        )
        next_node_rules do
          rule do
            set_membership_predicate("what_country_are_you_going_to?", ["narnia"])
            outcome("outcome_imaginary_country")
          end
          rule do
            set_membership_predicate("what_passport_do_you_have?", ["greek"])
            outcome("outcome_no_visa_needed")
          end
          rule do
            set_membership_predicate("what_passport_do_you_have?", ["british"])
            outcome("second_passport_question")
          end
        end
      end

      node("second_passport_question") do
        heading("What colour is your passport?")
        multiple_choice(
            "what_colour_is_your_passport?",
            {
                red: "Red",
                white: "White",
                blue: "Blue"
            }
        )
        next_node_rules do
          rule do
            outcome("outcome_passport_colour_specified")
          end
        end
      end

      node("outcome_no_visa_needed") do
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

      node("outcome_imaginary_country") do
        line("Imaginary country")
      end

      node("outcome_with_interpolation") do
        line("The answer is %{interpolated_variable}")
      end

      node("outcome_passport_colour_specified") do
        line("What a pretty passport")
      end
    end
  }

  describe "initial_state" do
    let(:lambda) {
      ->(state) { 'a_dynamic_state_object' }
    }
    let(:initial_state) { {
      key_1: 'a_state_object',
      key_2: :lambda
    } }
    let(:engine) { Smartdown::Engine.new(flow, initial_state) }
    subject(:state) { engine.process([]) }

    it "should have added initial_state to state" do
      expect(subject.get(:key_1)).to eql 'a_state_object'
      expect(subject.get(:key_2)).to eql :lambda
    end
  end

  describe "#process" do
    subject { engine.process(responses, start_state) }

    context "start button response only" do
      let(:responses) { %w{yes} }

      it { should be_a(Smartdown::Engine::State) }

      it "current_node of 'what_passport_do_you_have?'" do
        expect(subject.get(:current_node)).to eq("passport_question")
      end

      it "input recorded in state variable corresponding to node name" do
        expect(subject.get("check-uk-visa")).to eq(["yes"])
      end
    end

    context "one question per page" do
      context "greek passport" do
        let(:responses) { %w{yes greek} }

        it "is on outcome_no_visa_needed" do
          expect(subject.get(:current_node)).to eq("outcome_no_visa_needed")
        end

        it "has recorded input" do
          expect(subject.get("what_passport_do_you_have?")).to eq("greek")
        end

        it "recorded input is accessiable via question alias" do
          expect(subject.get("passport_type?")).to eq("greek")
        end

        context "extra answers passed" do
          let(:responses) { %w{yes greek I wanna be the very best like no one ever was} }
          it "return current_node as outcome and ignores extra responses" do
            expect(subject.get(:current_node)).to eq("outcome_no_visa_needed")
          end
        end
      end

      context "USA passport" do
        let(:responses) { %w{yes usa} }

        it "raises IndeterminateNextNode error" do
          expect { subject }.to raise_error(Smartdown::Engine::IndeterminateNextNode)
        end
      end

      context "no passport answer entered" do
        let(:responses) { ["yes", nil] }

        it "raises parsing errors" do
          expect(subject.get(:current_node)).to eq("passport_question")
          expect(subject.get("current_answers").count).to eq 1
          expect(subject.get("current_answers").first.error).to eq "Please answer this question"
        end
      end
    end

    context "two questions per page" do
      let(:flow) { two_questions_per_page_flow }
      context "narnia" do
        let(:responses) { %w{yes greek narnia} }

        it "is on outcome_no_visa_needed" do
          expect(subject.get(:current_node)).to eq("outcome_imaginary_country")
        end

        it "has recorded inputs" do
          expect(subject.get("what_passport_do_you_have?")).to eq("greek")
          expect(subject.get("what_country_are_you_going_to?")).to eq("narnia")
        end
      end

      context "usa" do
        let(:responses) { %w{yes greek usa} }

        it "is on outcome_no_visa_needed" do
          expect(subject.get(:current_node)).to eq("outcome_no_visa_needed")
        end

        it "has recorded inputs" do
          expect(subject.get("what_passport_do_you_have?")).to eq("greek")
          expect(subject.get("what_country_are_you_going_to?")).to eq("usa")
        end
      end

      context "no answers given" do
        let(:responses) { ["yes", nil, nil] }
        it "raises parsing errors" do
          expect(subject.get(:current_node)).to eq("passport_question")
          expect(subject.get("current_answers").count).to eq 2
          expect(subject.get("current_answers")[0].error).to eq "Please answer this question"
          expect(subject.get("current_answers")[1].error).to eq "Please answer this question"
          expect(subject.get("accepted_responses")).to eq ["yes"]
        end
      end

      context "only second answer given" do
        let(:responses) { ["yes", nil, "narnia"] }
        it "raises parsing errors" do
          expect(subject.get(:current_node)).to eq("passport_question")
          expect(subject.get("current_answers").count).to eq 2
          expect(subject.get("current_answers")[0].error).to eq "Please answer this question"
          expect(subject.get("current_answers")[1].error).to be nil
          expect(subject.get("accepted_responses")).to eq ["yes"]
        end
      end

      context "only first answer given" do
        let(:responses) { ["yes", "greek", nil] }
        it "raises parsing errors" do
          expect(subject.get(:current_node)).to eq("passport_question")
          expect(subject.get("current_answers").count).to eq 2
          expect(subject.get("current_answers")[0].error).to be nil
          expect(subject.get("current_answers")[1].error).to eq "Please answer this question"
          expect(subject.get("accepted_responses")).to eq ["yes"]
        end
      end

      context "british, going to usa" do
        let(:responses) { ["yes", "british", "usa", nil] }
        it "raises parsing errors" do
          expect(subject.get(:current_node)).to eq("second_passport_question")
          expect(subject.get("current_answers").count).to eq 1
          expect(subject.get("current_answers").first.error).to eq "Please answer this question"
          expect(subject.get("accepted_responses")).to eq ["yes", "british", "usa"]
        end
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
          line("True case")
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
          line("The answer is 42")
        end
      }

      it "evaluates the current node of the given state, resolving any conditionals" do
        expect(engine.evaluate_node(current_state)).to eq(expected_node_after_conditional_resolution)
      end
    end
  end

end
