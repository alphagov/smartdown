require 'smartdown/model/answer/date'
require 'smartdown/model/element/question/date'

describe Smartdown::Model::Answer::Salary do
  let(:salary_string) { "500-week" }
  let(:question) { Smartdown::Model::Element::Question::Date.new("a_date") }
  subject(:instance) { described_class.new(question, salary_string) }

  specify { expect(instance.period).to eql('week') }
  specify { expect(instance.amount_per_period).to eql(500.00) }

  it "as a string, it should declare itself in the initial format provided" do
    expect(instance.to_s).to eql("500.00 per week")
  end

  context "declared by week" do
    let(:salary_string) { "500-week" }
    specify { expect(instance.value).to eql 500.0 * 52 }
  end

  context "declared by month" do
    let(:salary_string) { "2000-month" }
    specify { expect(instance.value).to eql 2000.0 * 12 }
  end

  context "declared by year" do
    let(:salary_string) { "20000-year" }
    specify { expect(instance.value).to eql 20000.0 }
  end
end
