require 'smartdown/model/question/multiple_choice'
require 'smartdown/model/state'

describe Smartdown::Model::Question::MultipleChoice do

  let(:choices) {
    {
      "a" => "First one",
      "b" => "Second one"
    }
  }

  subject {
    Smartdown::Model::Question::MultipleChoice.new("a_or_b?", choices)
  }

  it "#name returns the name" do
    expect(subject.name).to eq("a_or_b?")
  end

  it "#choices returns the list of choices" do
    expect(subject.choices).to eq choices
  end

  it "#add_choice adds choices" do
    subject.add_choice(:yes, "Yes")
    expect(subject.choices).to have_key("yes")
    expect(subject.choices["yes"]).to eq "Yes"
  end

  it "#valid_choice? indicates if the choice was valid" do
    expect(subject.valid_choice?("a")).to eq(true)
    expect(subject.valid_choice?("First one")).to eq(false)
    expect(subject.valid_choice?("not_valid")).to eq(false)
  end

  it "#parse_input raises if the input is invalid" do
    expect { subject.parse_input("not_valid") }.to raise_error(Smartdown::InvalidResponse)
  end

  it "#parse_input returns the value if it was valid" do
    expect(subject.parse_input("a")).to eq("a")
  end
end
