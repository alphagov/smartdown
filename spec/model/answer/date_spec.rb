require 'smartdown/model/answer/date'
require 'smartdown/model/element/question/date'

describe Smartdown::Model::Answer::Date do
  let(:date_string) { "2014-9-4" }
  let(:question) { Smartdown::Model::Element::Question::Date.new("a_date") }
  subject(:instance) { described_class.new(question, date_string) }

  specify { expect(instance.value).to eql Date.new(2014, 9, 4) }
  specify { expect(instance.to_s).to eql "2014-9-4" }


  describe "comparisons" do
    let(:date_string) { "2000-1-10" }

    context "comparing against ::Dates" do

      specify { expect(instance == Date.new(2000, 1, 10)).to eql true }

      specify { expect(instance < Date.new(2000, 1, 11)).to eql true }
      specify { expect(instance < Date.new(2000, 1, 10)).to eql false }
      specify { expect(instance < Date.new(2000, 1, 9)).to eql false }

      specify { expect(instance > Date.new(2000, 1, 11)).to eql false }
      specify { expect(instance > Date.new(2000, 1, 10)).to eql false }
      specify { expect(instance > Date.new(2000, 1, 9)).to eql true }

      specify { expect(instance <= Date.new(2000, 1, 11)).to eql true }
      specify { expect(instance <= Date.new(2000, 1, 10)).to eql true }
      specify { expect(instance <= Date.new(2000, 1, 9)).to eql false }

      specify { expect(instance >= Date.new(2000, 1, 11)).to eql false }
      specify { expect(instance >= Date.new(2000, 1, 10)).to eql true }
      specify { expect(instance >= Date.new(2000, 1, 9)).to eql true }
    end

    context "comparing against strings" do
      specify { expect(instance == "2000-1-10").to eql true }

      specify { expect(instance < "2000-1-11").to eql true }
      specify { expect(instance < "2000-1-10").to eql false }
      specify { expect(instance < "2000-1-9").to eql false }

      specify { expect(instance > "2000-1-11").to eql false }
      specify { expect(instance > "2000-1-10").to eql false }
      specify { expect(instance > "2000-1-9").to eql true }

      specify { expect(instance <= "2000-1-11").to eql true }
      specify { expect(instance <= "2000-1-10").to eql true }
      specify { expect(instance <= "2000-1-9").to eql false }

      specify { expect(instance >= "2000-1-11").to eql false }
      specify { expect(instance >= "2000-1-10").to eql true }
      specify { expect(instance >= "2000-1-9").to eql true }
    end

    context "comparing against Answer::Dates" do
      specify { expect(instance == described_class.new(nil, "2000-1-10")).to eql true }

      specify { expect(instance < described_class.new(nil, "2000-1-11")).to eql true }
      specify { expect(instance < described_class.new(nil, "2000-1-10")).to eql false }
      specify { expect(instance < described_class.new(nil, "2000-1-9")).to eql false }

      specify { expect(instance > described_class.new(nil, "2000-1-11")).to eql false }
      specify { expect(instance > described_class.new(nil, "2000-1-10")).to eql false }
      specify { expect(instance > described_class.new(nil, "2000-1-9")).to eql true }

      specify { expect(instance <= described_class.new(nil, "2000-1-11")).to eql true }
      specify { expect(instance <= described_class.new(nil, "2000-1-10")).to eql true }
      specify { expect(instance <= described_class.new(nil, "2000-1-9")).to eql false }

      specify { expect(instance >= described_class.new(nil, "2000-1-11")).to eql false }
      specify { expect(instance >= described_class.new(nil, "2000-1-10")).to eql true }
      specify { expect(instance >= described_class.new(nil, "2000-1-9")).to eql true }
    end
  end
end
