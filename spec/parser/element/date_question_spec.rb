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
          option_pairs: [],
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

  context "with question tag and a date range with years" do
    let(:source) { "[date: date_of_birth, from: 1980, to: -2]" }

    it "parses" do
      should parse(source).as(
        date: {
          identifier: "date_of_birth",
          option_pairs: [
            {
              key: 'from',
              value: '1980',
            },
            {
              key: 'to',
              value: '-2',
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

     it { should eq(Smartdown::Model::Element::Question::Date.new("date_of_birth", '1980', '-2')) }
    end
  end

  context "with question tag and an alias" do
    let(:source) { "[date: date_of_birth, alias: date_for_adoption_or_birth]" }

    it "parses" do
      should parse(source).as(
        date: {
          identifier: "date_of_birth",
          option_pairs: [
            {
              key: 'alias',
              value: 'date_for_adoption_or_birth',
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

      it { should eq(Smartdown::Model::Element::Question::Date.new("date_of_birth", nil, nil, "date_for_adoption_or_birth")) }
    end
  end
end
