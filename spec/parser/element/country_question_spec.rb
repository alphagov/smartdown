require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/country_question'

describe Smartdown::Parser::Element::CountryQuestion do
  subject(:parser) { described_class.new }
  let(:data_module) { { 'country_data_all' => ->{{}} } }

  context "with question tag and countries" do
    let(:source) { "[country: country_of_residence, countries: country_data_all]" }

    it "parses" do
      should parse(source).as(
        country: {
          identifier: "country_of_residence",
          option_pairs:[
            {
              key: 'countries',
              value: 'country_data_all',
            },
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, data_module: data_module, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Country.new("country_of_residence", {})) }
    end

  end

  context "with question tag and countries, and alias" do
    let(:source) { "[country: country_of_residence, countries: country_data_all, alias: birthplace]" }

    it "parses" do
      should parse(source).as(
        country: {
          identifier: "country_of_residence",
          option_pairs:[
            {
              key: 'countries',
              value: 'country_data_all',
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
        Smartdown::Parser::NodeInterpreter.new(node_name, source, data_module: data_module, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Country.new("country_of_residence", {}, "birthplace")) }
    end

  end


end
