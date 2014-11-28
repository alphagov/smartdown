require 'smartdown/parser/predicates'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Predicates do
  subject(:parser) { described_class.new }

  describe "equality predicate" do
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
    it { should parse("my_pred?").as(named_predicate: "my_pred?") }
    it { should_not parse("my_pred") }
    it { should_not parse("my pred") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      let(:source) { "my_pred?" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Named.new("my_pred?")) }
    end
  end

  describe "otherwise predicate" do
    it { should parse("otherwise").as(otherwise_predicate: "otherwise") }
    it { should_not parse("other") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      let(:source) { "otherwise" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Otherwise.new) }
    end
  end

  describe "predicate AND predicate" do
    subject(:parser) { described_class.new }

    it { should parse("my_pred() AND my_other_pred?").as(
      { combined_predicate: {
        first_predicate: { function_predicate: { name: "my_pred" } },
        and_predicates:
          [
            {named_predicate: "my_other_pred?"},
          ]
      } }
    ) }
    it { should parse("my_pred? AND my_other_pred? AND varname in {a b c}").as(
      { combined_predicate: {
        first_predicate: { named_predicate: "my_pred?" },
        and_predicates:
          [
            {named_predicate: "my_other_pred?"},
            {set_membership_predicate:
              {varname: "varname", values: [{set_value: "a"}, {set_value: "b"}, {set_value: "c"}]}
            }
          ]
      } }
    ) }
    it { should_not parse("my_pred AND ") }

    describe "transformed" do
      let(:node_name) { "my_node" }
      let(:source) { "my_pred() AND my_other_pred?" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Predicate::Combined.new(
        [
          Smartdown::Model::Predicate::Function.new("my_pred", []),
          Smartdown::Model::Predicate::Named.new("my_other_pred?")
      ]
      )) }
    end
  end

  describe "function predicate" do

    context "no arguments" do
      let(:source) { "function_name()" }

      it { should parse(source).as(function_predicate: { name: "function_name" }) }
      it { should_not parse("function_name(") }

      describe "transformed" do
        let(:node_name) { "my_node" }
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it { should eq(Smartdown::Model::Predicate::Function.new("function_name", [])) }
      end
    end

    context "with ? in name" do
      let(:source) { "function_name?()" }

      it { should parse(source).as(function_predicate: { name: "function_name?" }) }

      describe "transformed" do
        let(:node_name) { "my_node" }
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it { should eq(Smartdown::Model::Predicate::Function.new("function_name?", [])) }
      end
    end

    context "single argument" do
      let(:source) { "function_name(arg_1)" }

      it { should parse(source).as(function_predicate: { name: "function_name", arguments: {function_argument: "arg_1"} }) }
      it { should_not parse("function_name(hello") }
      it { should_not parse("function name(hello)") }
      it { should_not parse("function_name(hello) foo") }

      describe "transformed" do
        let(:node_name) { "my_node" }
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it { should eq(Smartdown::Model::Predicate::Function.new("function_name", ["arg_1"])) }
      end
    end

    context "multiple arguments" do
      let(:source) { "function_name(arg_1 arg_2 arg_3)" }

      it { should parse(source).as(
        { function_predicate: {
          name: "function_name", arguments:
          [
            {function_argument: "arg_1"},
            {function_argument: "arg_2"},
            {function_argument: "arg_3"}
          ]
        } }
      ) }

      it { should_not parse("function_name(hello, foo") }
      it { should_not parse("function name(hello, foo, bar) bar") }

      describe "transformed" do
        let(:node_name) { "my_node" }
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it { should eq(Smartdown::Model::Predicate::Function.new("function_name", ["arg_1", "arg_2", "arg_3"])) }
      end
    end
  end

  describe "comparison predicate" do
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
      context "greater or equal" do
        let(:source) { greater_equal_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::GreaterOrEqual.new("varname", "value")) }
      end
      context "greater" do
        let(:source) { greater_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::Greater.new("varname", "value")) }
      end
      context "less than or equal" do
        let(:source) { less_equal_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::LessOrEqual.new("varname", "value")) }
      end
      context "less than" do
        let(:source) { less_source }
        it { should eq(Smartdown::Model::Predicate::Comparison::Less.new("varname", "value")) }
      end
    end
  end
end

