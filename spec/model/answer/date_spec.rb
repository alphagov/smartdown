require 'smartdown/model/answer/date'
require 'smartdown/model/element/question/date'

describe Smartdown::Model::Answer::Date do
  let(:date_string) { "2014-9-4" }
  let(:question) { Smartdown::Model::Element::Question::Date.new("a_date") }
  subject(:instance) { described_class.new(date_string, question) }

  specify { expect(instance.value).to eql Date.new(2014, 9, 4) }
  specify { expect(instance.to_s).to eql "2014-9-4" }

  describe "humanize" do
    let(:date_string) { "2000-1-10" }
    specify { expect(instance.humanize).to eql "10 January 2000" }
  end

  describe "errors" do

    context "format is incorrect" do
      let(:date_string) { "tomorrow" }
      specify { expect(instance.error).to eql "Invalid date" }
      specify { expect(instance.value).to eql nil }
    end

    context "answer not filled in" do
      let(:date_string) { nil }
      specify { expect(instance.error).to eql "Please answer this question" }
      specify { expect(instance.value).to eql nil }
    end
  end

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
      specify { expect(instance == described_class.new("2000-1-10")).to eql true }

      specify { expect(instance < described_class.new("2000-1-11")).to eql true }
      specify { expect(instance < described_class.new("2000-1-10")).to eql false }
      specify { expect(instance < described_class.new("2000-1-9")).to eql false }

      specify { expect(instance > described_class.new("2000-1-11")).to eql false }
      specify { expect(instance > described_class.new("2000-1-10")).to eql false }
      specify { expect(instance > described_class.new("2000-1-9")).to eql true }

      specify { expect(instance <= described_class.new("2000-1-11")).to eql true }
      specify { expect(instance <= described_class.new("2000-1-10")).to eql true }
      specify { expect(instance <= described_class.new("2000-1-9")).to eql false }

      specify { expect(instance >= described_class.new("2000-1-11")).to eql false }
      specify { expect(instance >= described_class.new("2000-1-10")).to eql true }
      specify { expect(instance >= described_class.new("2000-1-9")).to eql true }
    end
  end
end
