require 'smartdown/parser/element/front_matter'
require 'smartdown/parser/node_transform'

describe Smartdown::Parser::Element::FrontMatter do

  subject(:parser) { described_class.new }

  it { should parse("a: 1\n").as(front_matter: [{name: "a", value: "1"}]) }
  it { should parse("a: 1\nb: 2\n").as(front_matter: [{name: "a", value: "1"}, {name: "b", value: "2"}]) }

  describe "transforming" do
    let(:transform) { Smartdown::Parser::NodeTransform.new }
    let(:source) { "a: 1\n" }
    let(:node_name) { "my_node" }

    subject(:transformed) {
      transform.apply(parser.parse(source), node_name: node_name)
    }

    it "should build a FrontMatter model" do
      expect(transformed).to eq([Smartdown::Model::FrontMatter.new("a"=>"1")])
    end
  end
end

