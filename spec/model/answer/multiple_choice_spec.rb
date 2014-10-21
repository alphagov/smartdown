# encoding: utf-8
require 'smartdown/model/answer/multiple_choice'

describe Smartdown::Model::Answer::MultipleChoice do

  subject(:answer) { described_class.new("answer", multiple_choice_question) }
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
end
