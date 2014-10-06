# encoding: utf-8
require 'smartdown/model/answer/money'

describe Smartdown::Model::Answer::Money do

  let(:money_float) { 523.42 }
  subject(:instance) { described_class.new(nil, money_float) }

  describe "#humanize" do
    it "specifies money in the correct format" do
      expect(instance.humanize).to eql("£523.42")
    end
    context "rounding up" do
      let(:money_float) { 523.427 }
      it "rounds up amounts of money correctly" do
        expect(instance.humanize).to eql("£523.43")
      end
    end
    context "rounding down" do
      let(:money_float) { 523.421 }
      it "rounds down amounts of money correctly" do
        expect(instance.humanize).to eql("£523.42")
      end
    end
    context "rounds down in the .005 case" do
      let(:money_float) { 523.425 }
      it "rounds down amounts of money correctly" do
        expect(instance.humanize).to eql("£523.42")
      end
    end
  end
end
