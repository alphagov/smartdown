require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::StartButton do
  subject(:parser) { described_class.new }

  it "parses a start indicator with a question identifier" do
    should parse("[start: first_question?]").as({start_button: "first_question?"})
    should parse("[start: first_question?]\n").as({start_button: "first_question?"})
  end

  it "requires a question identifier" do
    should_not parse("[start]")
  end

  it "does not allow spaces in question identifier" do
    should_not parse("[start: first question]")
  end

  describe "transformed" do
    let(:node_name) { "my_node" }
    let(:source) { "[start: first_question?]\n" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Element::StartButton.new("first_question?")) }
  end
end
