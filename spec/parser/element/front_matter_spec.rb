require 'smartdown/parser/element/front_matter'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::FrontMatter do

  subject(:parser) { described_class.new }

  it { should parse("a: 1\n").as(front_matter: [{name: "a", value: "1"}]) }
  it { should parse("a: 1\nb: 2\n").as(front_matter: [{name: "a", value: "1"}, {name: "b", value: "2"}]) }

  describe "transformed" do
    let(:node_name) { "my_node" }
    let(:source) { "a: 1\n" }
    subject(:transformed) {
      Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
    }

    it { should eq([Smartdown::Model::FrontMatter.new("a"=>"1")]) }
  end
end

