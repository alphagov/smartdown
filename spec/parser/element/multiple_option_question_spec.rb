require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::MultipleOptionQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) {
      [
        "[options: identifier]",
        "* option-a: Option A",
        "* option-b: Option B"
      ].join("\n")
    }

    it "parses" do
      should parse(source).as(
        multiple_option: {
          identifier: "identifier",
          options: [
            {value: "option-a", label: "Option A"},
            {value: "option-b", label: "Option B"}
          ],
          option_pairs: [],
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::MultipleOption.new("identifier", {"option-a"=>"Option A", "option-b"=>"Option B"})) }
    end
  end
end
