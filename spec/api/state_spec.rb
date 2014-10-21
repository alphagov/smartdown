require 'smartdown/api/state'

describe Smartdown::Api::State do

  subject(:state) { Smartdown::Api::State.new(current_node, previous_questionpage_smartdown_nodes, responses)}
  let(:current_node) { double(:current_node) }
  let(:previous_questionpage_smartdown_nodes) { [question_page_node_1, question_page_node_2] }
  let(:question_page_node_1) { double(:question_page_node_1, :questions => [double, double]) }
  let(:question_page_node_2) { double(:question_page_node_2, :questions => [double]) }
  let(:responses) { ["a", "b", "c"] }
  let(:previous_question_page_class) { double(:previous_question_page_class, :new => nil)}

  describe "#previous_question_pages" do
    it "creates question pages with their corresponding responses" do
      stub_const("Smartdown::Api::PreviousQuestionPage", previous_question_page_class)
      state.previous_question_pages(responses)
      expect(Smartdown::Api::PreviousQuestionPage).to have_received(:new)
                                                  .with(question_page_node_1, ["a", "b"])
      expect(Smartdown::Api::PreviousQuestionPage).to have_received(:new)
                                                  .with(question_page_node_2, ["c"])
    end
  end
end
