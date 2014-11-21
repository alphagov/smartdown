require 'smartdown/api/date_question'
require 'smartdown/model/element/question/date'

describe Smartdown::Api::DateQuestion do
  before do
    Timecop.freeze(Time.local(2014))
  end

  after do
    Timecop.return
  end

  subject(:date_question) { Smartdown::Api::DateQuestion.new(elements) }
  let(:elements) { [ date_question_element ] }
  let(:date_question_element) {
    Smartdown::Model::Element::Question::Date.new(name, *args)
  }
  let(:aliaz) { nil }
  let(:args) {[start_year, end_year, aliaz]}


  context "no to/from provided" do
    let(:name)       { 'year_of_emancipation' }
    let(:start_year) { nil }
    let(:end_year)   { nil }

    describe "#start_year" do
      it 'returns good default' do
        expect(date_question.start_year).to eq(Time.now.year - 1)
      end
    end

    describe "#end_year" do
      it 'returns good default' do
        expect(date_question.end_year).to eq(Time.now.year + 3)
      end
    end
  end

  context "with to/from provided" do
    context "Fixed years" do
      let(:name)       { 'year_of_incarceration_for_possession_of_alcohol' }
      let(:start_year) { '1920' }
      let(:end_year)   { '1933' }

      describe "start_year" do
        specify { expect(date_question.start_year).to eq(start_year.to_i) }
      end

      describe "end_year" do
        specify { expect(date_question.end_year).to eq(end_year.to_i) }
      end
    end

    context "Relative years" do
      let(:name)       { 'year_of_incarceration_for_practicing_witchcraft' }
      let(:start_year) { '-279' }
      let(:end_year)   { '-63' }

      describe "start_year" do
        specify { expect(date_question.start_year).to eq(1735) }
      end

      describe "end_year" do
        specify { expect(date_question.end_year).to eq(1951) }
      end

    end
  end

end
