require 'smartdown/parser/element/markdown_heading'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::MarkdownHeading do

  subject(:parser) { described_class.new }
  let(:node_name) { "my_node" }
  let(:heading_content) { "My heading"}
  let(:source) { "# #{heading_content}" }

  it { should parse(source).as(h1: heading_content) }
  it { should parse("# heading\n").as(h1: "heading") }
  it { should parse("# heading   \n").as(h1: "heading") }
  it { should parse("# heading   ").as(h1: "heading") }

  describe "transformed" do
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Element::MarkdownHeading.new(heading_content)) }
  end
end

