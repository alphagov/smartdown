require 'smartdown/parser/element/next_steps'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::NextSteps do
  subject(:parser) { described_class.new }

  let(:source) {
    [
      "[next_steps]",
      "some markdown",
      "some more markdown",
      "[end_next_steps]"
    ].join("\n")
  }

  it "parses" do
    should parse(source).as(
      next_steps: {
        content: "some markdown\nsome more markdown\n"
      }
    )
  end

  describe "transformed" do
    let(:node_name) { "my_node" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Element::NextSteps.new("some markdown\nsome more markdown\n")) }
  end
end
