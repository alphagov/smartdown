require 'smartdown/parser/predicates'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Predicates do

  describe "equality predicate" do
    subject(:parser) { described_class.new }
    let(:source) { "varname is 'expected_value'" }

    it { should parse(source).as(equality_predicate: {varname: "varname", expected_value: "expected_value"}) }
    it { should_not parse("v is value") }
    it { should_not parse("v is 'a thing's thing'") }
    it { should_not parse("v is 'a thing\\'s thing'") }
    it { should_not parse(%q{v is "a thing"}) }

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

  describe "named predicate" do
    subject(:parser) { described_class.new }

    it { should parse("my_pred").as(named_predicate: "my_pred") }
    it { should parse("my_pred?").as(named_predicate: "my_pred?") }
    it { should_not parse("my pred") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      let(:source) { "my_pred" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Named.new("my_pred")) }
    end
  end

  describe "predicate AND predicate" do
    subject(:parser) { described_class.new }

    it { should parse("my_pred AND my_other_pred").as(
      { combined_predicate: {
        first_predicate: { named_predicate: "my_pred" },
        and_predicates:
          [
            {named_predicate: "my_other_pred"},
          ]
      } }
    ) }
    it { should parse("my_pred AND my_other_pred AND varname in {a b c}").as(
      { combined_predicate: {
        first_predicate: { named_predicate: "my_pred" },
        and_predicates:
          [
            {named_predicate: "my_other_pred"},
            {set_membership_predicate:
              {varname: "varname", values: [{set_value: "a"}, {set_value: "b"}, {set_value: "c"}]}
            }
          ]
      } }
    ) }
    it { should_not parse("my_pred AND ") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      let(:source) { "my_pred AND my_other_pred" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Combined.new(
        [
          Smartdown::Model::Predicate::Named.new("my_pred"),
          Smartdown::Model::Predicate::Named.new("my_other_pred")
        ]
      )) }
    end
  end

  describe "comparison predicate" do
    subject(:parser) { described_class.new }
    let(:greater_equal_source) { "varname >= 'value'" }
    let(:greater_source) { "varname > 'value'" }
    let(:less_equal_source) { "varname <= 'value'" }
    let(:less_source) { "varname < 'value'" }

    it { should parse(greater_equal_source).as(comparison_predicate: {varname: "varname", value: "value", operator: ">="}) }
    it { should_not parse("v >= value") }
    it { should_not parse("v >= 'a thing's thing'") }
    it { should_not parse("v >= 'a thing\\'s thing'") }
    it { should_not parse(%q{v >= "a thing"}) }

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }
      context "greater" do
        let(:source) { greater_equal_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::GreaterOrEqual.new("varname", "value")) }
      end
      context "stricly greater" do
        let(:source) { greater_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::Greater.new("varname", "value")) }
      end
      context "lower" do
        let(:source) { less_equal_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::LessOrEqual.new("varname", "value")) }
      end
      context "strictly lower" do
        let(:source) { less_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::Less.new("varname", "value")) }
      end
    end
  end
end

