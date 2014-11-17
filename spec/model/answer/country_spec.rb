describe Smartdown::Model::Answer::Country do
  let(:text_string) { "United Kingdom" }
  subject(:instance) { described_class.new(text_string) }


  let(:answer_string) { "country" }
  subject(:answer) { described_class.new(answer_string, multiple_choice_question) }
  let(:multiple_choice_question) {
    Smartdown::Model::Element::Question::Country.new("question",
                                                     {"country" => "Lovely country"}
    )
  }

  describe "#humanize" do
    it "returns the humanized answer" do
      expect(answer.humanize).to eq "Lovely country"
    end
  end

  describe "errors" do
    context "format is incorrect" do
      let(:answer_string) { "kasjdf" }
      specify { expect(answer.error).to eql "Invalid country" }
    end

    context "answer not filled in" do
      let(:answer_string) { nil }
      specify { expect(answer.error).to eql "Please answer this question" }
    end
  end
end
