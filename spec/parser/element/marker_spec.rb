require 'smartdown/parser/element/marker'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::Marker do
  subject(:parser) { described_class.new }

  it "parses a marker with a marker name" do
    should parse("{{marker: hello_there}}").as({marker: "hello_there"})
    should parse("{{marker: hello_there}}\n").as({marker: "hello_there"})
  end

  it "requires a name" do
    should_not parse("{{marker:}}")
  end

  it "does not allow spaces in name" do
    should_not parse("{{marker: hello there}}")
  end

  describe "transformed" do
    let(:node_name) { "my_node" }
    let(:source) { "{{marker: hello_there}}\n" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq(Smartdown::Model::Element::Marker.new("hello_there")) }
  end
end
