require 'smartdown/parser/predicates'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Predicates do

  describe "equality predicate" do
    subject(:parser) { described_class.new }
    let(:source) { "varname is 'expected_value'" }

    it { should parse(source).as(equality_predicate: {varname: "varname", expected_value: "expected_value"}) }

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Equality.new("varname", "expected_value")) }
    end
  end

  describe "set membership predicate" do
    subject(:parser) { described_class.new }
    let(:source) { "varname in {a b c}" }

    it { should parse(source).as(set_membership_predicate: {varname: "varname", values: [{set_value: "a"}, {set_value: "b"}, {set_value: "c"}]}) }
    it { should parse('v in {}').as(set_membership_predicate: {varname: "v", values: nil}) }
    it { should parse('v in { }').as(set_membership_predicate: {varname: "v", values: nil}) }
    it { should parse('v   in   { }').as(set_membership_predicate: {varname: "v", values: nil}) }
    it { should_not parse('vin {}') }
    it { should_not parse("v in {\n}") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::SetMembership.new("varname", ["a", "b", "c"])) }
    end
  end
end

