require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::MultipleChoiceQuestion do
  subject(:parser) { described_class.new }
  let(:source) {
    [
      "* yes: Yes",
      "* no: No"
    ].join("\n")
  }

  it "parses" do
    should parse(source).as(
      multiple_choice: [
        {value: "yes", label: "Yes"},
        {value: "no", label: "No"}
      ]
    )
  end

  describe "transformed" do
    let(:node_name) { "my_node" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Question::MultipleChoice.new(node_name, {"yes"=>"Yes", "no"=>"No"})) }
  end
end
