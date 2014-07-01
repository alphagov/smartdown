require 'smartdown/parser/rules'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Rules do

  describe "simple rule" do
    subject(:parser) { described_class.new }
    let(:source) { "* my_pred? => outcome" }

    it { should parse(source).as([{rule: {predicate: {named_predicate: "my_pred?"}, outcome: "outcome"}}]) }

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(
        [
          Smartdown::Model::Rule.new(
            Smartdown::Model::Predicate::Named.new("my_pred"),
            "outcome"
          )
        ]
      ) }
    end
  end
end

