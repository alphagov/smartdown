require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/date_question'

describe Smartdown::Parser::Element::DateQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) { "[date: date_of_birth]" }

    it "parses" do
      should parse(source).as(
        date: {
          identifier: "date_of_birth",
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Date.new("date_of_birth")) }
    end
  end
end
