require 'smartdown/model/answer/base'

describe Smartdown::Model::Answer::Base do
  let(:question) { :a_question }
  let(:value) { 'a value' }

  subject(:instance) {Smartdown::Model::Answer::Base.new(value, question)}

  specify { expect(instance.question).to eql question }

  describe "value parsing" do
    it "should assign the return value of parse_value (to be implemented by sub-classes) to value" do
      expect_any_instance_of(Smartdown::Model::Answer::Base).to receive(:parse_value).with(value).and_return("parsed value")
      expect(instance.value).to eql "parsed value"
    end
  end

  describe "simple type behaviour" do
    [:==, :<, :>, :<=, :>=, :to_s, :to_i, :to_f, :+, :-, :*, :/].each do |method|
      it { should respond_to(method) }
    end
  end

  describe 'validations' do
    describe 'valid?' do
      it 'returns true if there are no errors on the question' do
        expect(instance).to be_valid
      end

      it "has no error defined" do
        expect(instance.error).to be nil
      end

      context "answer has been given a nil value" do
        let(:value) { nil }
        it 'returns false if there are no errors on the question' do
          expect(instance).not_to be_valid
        end
        it "has an error asking for user to input a value" do
          expect(instance.error).to eq "Please answer this question"
        end
      end
    end
  end
end
