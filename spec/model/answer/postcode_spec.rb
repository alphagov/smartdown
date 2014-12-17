# encoding: utf-8
require 'smartdown/model/answer/postcode'

describe Smartdown::Model::Answer::Postcode do

  let(:answer_string) { "WC2B 6SE" }
  subject(:answer) { described_class.new(answer_string) }

  describe "#humanize" do
    it "declares itself in the initial format provided" do
      expect(answer.humanize).to eql("WC2B 6SE")
    end
  end

  describe "errors" do
    context "partial postcodes are not allowed" do
      let(:answer_string) { "WC2B" }
      specify { expect(answer.error).to eql "Please enter a full postcode" }
      specify { expect(answer.value).to eql "WC2B" }
    end

    context "invalid postcode" do
      let(:answer_string) { "invalid" }
      specify { expect(answer.error).to eql "Invalid postcode" }
      specify { expect(answer.value).to eql "invalid" }
    end

    context "question not answered" do
      let(:answer_string) { nil }
      specify { expect(answer.error).to eql "Please answer this question" }
    end
  end
end
