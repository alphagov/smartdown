require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/salary_question'

describe Smartdown::Parser::Element::SalaryQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) { "[salary: mother_salary]" }

    it "parses" do
      should parse(source).as(
        salary: {
          identifier: "mother_salary",
          option_pairs:[],
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Salary.new("mother_salary")) }
    end
  end

  context "with question tag and alias" do
    let(:source) { "[salary: mother_salary, alias: mums_salary]" }

    it "parses" do
      should parse(source).as(
        salary: {
          identifier: "mother_salary",
          option_pairs: [
            {
              key: 'alias',
              value: 'mums_salary',
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

      it { should eq(Smartdown::Model::Element::Question::Salary.new("mother_salary", "mums_salary")) }
    end
  end

end
