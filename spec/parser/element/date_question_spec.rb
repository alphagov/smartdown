require 'smartdown/parser/element/date_question'
require 'smartdown/model/element/date_question'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::DateQuestion do
  subject(:parser) { described_class.new }

    let(:source) { "[date: start_date]" }

    it "parses" do
      should parse(source).as(
        date: {
          identifier: "start_date",
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::DateQuestion.new("start_date")) }
    end
end
