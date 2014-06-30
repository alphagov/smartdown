require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_transform'

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

  describe "transforming" do
    let(:transform) { Smartdown::Parser::NodeTransform.new }
    let(:node_name) { "my_node" }

    subject(:transformed) {
      transform.apply(parser.parse(source), node_name: node_name)
    }

    it "should build a model" do
      expect(transformed).to eq(Smartdown::Model::Question::MultipleChoice.new(node_name, {"yes"=>"Yes", "no"=>"No"}))
    end
  end
end
