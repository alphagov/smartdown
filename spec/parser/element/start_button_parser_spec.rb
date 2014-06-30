require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'

describe Smartdown::Parser::Element::StartButton do
  subject { described_class.new }

  it "should parse a start indicator with a question identifier" do
    should parse("[start: first_question?]").as({start_button: "first_question?"})
    should parse("[start: first_question?]\n").as({start_button: "first_question?"})
  end

  it "should require a question identifier" do
    should_not parse("[start]")
  end

  it "should not allow question identifier to contain spaces" do
    should_not parse("[start: first question]")
  end
end
