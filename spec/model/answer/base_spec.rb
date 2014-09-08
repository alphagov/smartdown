require 'smartdown/model/answer/base'

describe Smartdown::Model::Answer::Base do
  let(:question) { :a_question }
  let(:value) { 'a value' }

  subject(:instance) {Smartdown::Model::Answer::Base.new(question, value)}

  specify { expect(instance.question).to eql question }

  describe "value parsing" do
    it "should assign the return value of parse_value (to be implemented by sub-classes) to value" do
      expect_any_instance_of(Smartdown::Model::Answer::Base).to receive(:parse_value).with(value).and_return("parsed value")
      expect(instance.value).to eql "parsed value"
    end
  end

  specify { expect(instance.to_s).to eql "a value" }

  describe "comparisons" do
    context "with a string kind of answer" do
      specify { expect(instance == "a value").to eql true }
    end

    context "with an integer kind of answer" do
      class TestIntegerAnswer < described_class
        def parse_value(value)
          value.to_i
        end
      end
      let(:value) { "10" }
      subject(:instance) { TestIntegerAnswer.new(question, value) }

      context "comparing against integers" do
        specify { expect(instance == 10).to eql true }

        specify { expect(instance < 11).to eql true }
        specify { expect(instance < 10).to eql false }
        specify { expect(instance < 9).to eql false }

        specify { expect(instance > 11).to eql false }
        specify { expect(instance > 10).to eql false }
        specify { expect(instance > 9).to eql true }

        specify { expect(instance <= 11).to eql true }
        specify { expect(instance <= 10).to eql true }
        specify { expect(instance <= 9).to eql false }

        specify { expect(instance >= 11).to eql false }
        specify { expect(instance >= 10).to eql true }
        specify { expect(instance >= 9).to eql true }
      end

      context "comparing against strings" do
        specify { expect(instance == "10").to eql true }

        specify { expect(instance < "11").to eql true }
        specify { expect(instance < "10").to eql false }
        specify { expect(instance < "9").to eql false }

        specify { expect(instance > "11").to eql false }
        specify { expect(instance > "10").to eql false }
        specify { expect(instance > "9").to eql true }

        specify { expect(instance <= "11").to eql true }
        specify { expect(instance <= "10").to eql true }
        specify { expect(instance <= "9").to eql false }

        specify { expect(instance >= "11").to eql false }
        specify { expect(instance >= "10").to eql true }
        specify { expect(instance >= "9").to eql true }
      end
    end
  end
end
