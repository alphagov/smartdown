# encoding: utf-8
require 'smartdown/model/answer/money'

describe Smartdown::Model::Answer::Money do

  let(:money_string) { '1523.42' }
  subject(:instance) { described_class.new(money_string) }

  specify { expect(instance.value).to eql(1523.42) }

  describe 'to_s' do
    it "returns value without comma delimiter" do
      expect(instance.to_s).to eql("1523.42")
    end
  end

  describe "#humanize" do
    it "specifies money in the correct format" do
      expect(instance.humanize).to eql("£1,523.42")
    end

    context "rounding up" do
      let(:money_string) { '1523.427' }
      it "rounds up amounts of money correctly" do
        expect(instance.humanize).to eql("£1,523.43")
      end
    end
    context "rounding down" do
      let(:money_string) { '1523.421' }
      it "rounds down amounts of money correctly" do
        expect(instance.humanize).to eql("£1,523.42")
      end
    end
    context "rounds down in the .005 case" do
      let(:money_string) { '1523.425' }
      it "rounds down amounts of money correctly" do
        expect(instance.humanize).to eql("£1,523.42")
      end
    end
    context "no pence" do
      let(:money_string) { '1523.00' }
      it "rounds down amounts of money correctly" do
        expect(instance.humanize).to eql("£1,523")
      end
    end
  end

  describe "errors" do
    context "invalid formatting" do
      let(:money_string) {"Loads'a'money"}

      it "Has errors" do
        expect(instance.error).to eql("Invalid format")
      end
    end

    context "no input" do
      let(:money_string) { nil }

      it "Has errors" do
        expect(instance.error).to eql("Please answer this question")
      end
    end
  end

  describe "comparisons" do
    let(:money_string) { '62,400' }

    context "comparing against Float" do
      specify { expect(instance == 62400.0).to eql true }

      specify { expect(instance < 62400.1).to eql true }
      specify { expect(instance < 62400.0).to eql false }
      specify { expect(instance < 62399.9).to eql false }

      specify { expect(instance > 62400.1).to eql false }
      specify { expect(instance > 62400.0).to eql false }
      specify { expect(instance > 62399.9).to eql true }

      specify { expect(instance <= 62400.1).to eql true }
      specify { expect(instance <= 62400.0).to eql true }
      specify { expect(instance <= 62399.9).to eql false }

      specify { expect(instance >= 62400.1).to eql false }
      specify { expect(instance >= 62400.0).to eql true }
      specify { expect(instance >= 62399.9).to eql true }
    end

    context "comparing against Integer" do
      specify { expect(instance == 62400).to eql true }

      specify { expect(instance < 62401).to eql true }
      specify { expect(instance < 62400).to eql false }
      specify { expect(instance < 62399).to eql false }

      specify { expect(instance > 62401).to eql false }
      specify { expect(instance > 62400).to eql false }
      specify { expect(instance > 62399).to eql true }

      specify { expect(instance <= 62401).to eql true }
      specify { expect(instance <= 62400).to eql true }
      specify { expect(instance <= 62399).to eql false }

      specify { expect(instance >= 62401).to eql false }
      specify { expect(instance >= 62400).to eql true }
      specify { expect(instance >= 62399).to eql true }
    end

    context "comparing against strings" do
      specify { expect(instance == '62400').to eql true }
      specify { expect(instance < '62400.1').to eql true }
      specify { expect(instance > '62400').to eql false }
      specify { expect(instance <= '62400.1').to eql true }
      specify { expect(instance >= '62400').to eql true }
    end

    context "comparing against Answer::Money" do
      specify { expect(instance == described_class.new(money_string)).to eql true }

      specify { expect(instance < described_class.new('62,400.1')).to eql true }
      specify { expect(instance < described_class.new('62,400')).to eql false }
      specify { expect(instance < described_class.new('62,399.99')).to eql false }

      specify { expect(instance > described_class.new('62,400.1')).to eql false }
      specify { expect(instance > described_class.new('62,400')).to eql false }
      specify { expect(instance > described_class.new('62,399.99')).to eql true }

      specify { expect(instance <= described_class.new('62,400.1')).to eql true }
      specify { expect(instance <= described_class.new('62,400')).to eql true }
      specify { expect(instance <= described_class.new('62,399.99')).to eql false }

      specify { expect(instance >= described_class.new('62,400.1')).to eql false }
      specify { expect(instance >= described_class.new('62,400')).to eql true }
      specify { expect(instance >= described_class.new('62,399.99')).to eql true }
    end
  end
end
