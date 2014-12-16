require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/postcode_question'

describe Smartdown::Parser::Element::PostcodeQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) { "[postcode: home]" }

    it "parses" do
      should parse(source).as(
        postcode: {
          identifier: "home",
          option_pairs: [],
        },
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Postcode.new("home")) }
    end
  end

  context "with question tag and alias" do
    let(:source) { "[postcode: home, alias: sweet_home]" }

    it "parses" do
      should parse(source).as(
        postcode: {
          identifier: "home",
          option_pairs:[
            {
              key: 'alias',
              value: 'sweet_home',
            }
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Postcode.new("home", "sweet_home")) }
    end
  end

end
