require 'smartdown/model/answer/multiple_option'

describe Smartdown::Model::Answer::MultipleOption do

  let(:answers) { %w(option-a option-c) }
  subject(:answer) { described_class.new(answers, multiple_option_question) }
  let(:multiple_option_question) {
    Smartdown::Model::Element::Question::MultipleOption.new("question", {
      "option-a" => "Option A",
      "option-b" => "Option B",
      "option-c" => "Option C"
    })
  }

  describe "#humanize" do
    it "returns the humanized answer" do
      expect(answer.humanize).to eq "Option A, Option C"
    end
  end

  describe "errors" do
    context "format is incorrect" do
      let(:answers) { %w(abc def) }
      specify { expect(answer.error).to eql "Invalid choice(s)" }
    end

    context "answer not filled in" do
      let(:answer_string) { nil }
      specify { expect(answer.error).to eql "Please answer this question" }
    end
  end
end
