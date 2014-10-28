require 'smartdown/api/previous_question'
require 'smartdown/api/multiple_choice'

describe Smartdown::Api::PreviousQuestion do

  subject(:previous_question) { Smartdown::Api::PreviousQuestion.new(elements, response)}
  let(:elements) { [ multiple_choice_element ] }
  let(:multiple_choice_element) {
    Smartdown::Model::Element::Question::MultipleChoice.new("question",
                                                            {"answer" => "Beautiful answer"}
    )
  }
  let(:response) { double(:response) }
  let(:multiple_choice_class) { double(:multiple_choice_class, :new => nil) }
  let(:answer_type) { double(:answer_type) }

  describe "#question" do
    it "is of the correct type" do
      expect(previous_question.question).to be_instance_of(Smartdown::Api::MultipleChoice)
    end
  end

  describe "#answer" do
    it "is of the correct type" do
      expect(previous_question.answer).to be_instance_of(Smartdown::Model::Answer::MultipleChoice)
    end
  end

end
