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
end
