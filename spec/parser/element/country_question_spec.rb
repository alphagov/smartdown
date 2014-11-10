require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/country_question'

describe Smartdown::Parser::Element::CountryQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) { "[country: country_of_residence]" }

    it "parses" do
      should parse(source).as(
        country: {
          identifier: "country_of_residence",
          option_pairs: [],
        },
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Country.new("country_of_residence")) }
    end

  end

  context "with question tag and alias" do
    let(:source) { "[country: country_of_residence, alias: birthplace]" }

    it "parses" do
      should parse(source).as(
        country: {
          identifier: "country_of_residence",
          option_pairs:[
            {
              key: 'alias',
              value: 'birthplace',
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

      it { should eq(Smartdown::Model::Element::Question::Country.new("country_of_residence", "birthplace")) }
    end

  end

  context "with question tag and countries, and alias" do
    let(:source) { "[country: country_of_residence, countries: get_all_countries, alias: birthplace]" }

    it "parses" do
      should parse(source).as(
        country: {
          identifier: "country_of_residence",
          option_pairs:[
            {
              key: 'countries',
              value: 'get_all_countries',
            },
            {
              key: 'alias',
              value: 'birthplace',
            },
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Country.new("country_of_residence", "birthplace")) }
    end

  end


end
