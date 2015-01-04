require 'smartdown/parser/element/markdown_line'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::MarkdownLine do

  subject(:parser) { described_class.new }
  let(:node_name) { "my_node" }

  it { should parse("My para").as(line: "My para") }
  it { should_not parse("My para\n").as(line: "My para\n") }
  it { should parse(" My para").as(line: " My para") }
  it { should_not parse(" My para\nsecond line") }
  it { should_not parse(" My para\nsecond line\n") }
  it { should_not parse(" My para\nsecond line   \n") }
  it { should_not parse("Para1\n\nPara2") }

  it { should parse("a   b") }

  describe "transformed" do
    let(:content) { "My para" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, content, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Element::MarkdownLine.new(content)) }
  end
end

