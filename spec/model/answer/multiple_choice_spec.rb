# encoding: utf-8
require 'smartdown/model/answer/multiple_choice'

describe Smartdown::Model::Answer::MultipleChoice do

  let(:answer_string) { "answer" }
  subject(:answer) { described_class.new(answer_string, multiple_choice_question) }
  let(:multiple_choice_question) {
    Smartdown::Model::Element::Question::MultipleChoice.new("question",
                                                            {"answer" => "Beautiful answer"}
    )
  }

  describe "#humanize" do
    it "returns the humanized answer" do
      expect(answer.humanize).to eq "Beautiful answer"
    end
  end

  describe "errors" do
    context "format is incorrect" do
      let(:answer_string) { "kasjdf" }
      specify { expect(answer.error).to eql "Invalid choice" }
    end

    context "answer not filled in" do
      let(:answer_string) { nil }
      specify { expect(answer.error).to eql "Please answer this question" }
    end
  end
end
