require 'smartdown/parser/rules'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Rules do
  subject(:parser) { described_class.new }
  let(:node_name) { "my_node" }

  describe "simple rule" do
    let(:source) { "* my_pred? => outcome" }

    it { should parse(source).as([{rule: {predicate: {named_predicate: "my_pred?"}, outcome: "outcome"}}]) }

    describe "transformed" do
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(
        [
          Smartdown::Model::Rule.new(
            Smartdown::Model::Predicate::Named.new("my_pred?"),
            "outcome"
          )
        ]
      ) }
    end
  end

  describe "nested rule" do
    describe "one rule nested" do
      subject(:parser) { described_class.new }
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  " + child_rule
        ].join("\n")
      }
      let(:parsed_child_rule) { parser.parse(child_rule) }

      it { should parse(source).as([{nested_rule: {predicate: {named_predicate: "pred1?"}, child_rules: parsed_child_rule}}]) }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            [
              Smartdown::Model::NestedRule.new(
                Smartdown::Model::Predicate::Named.new("pred1?"),
                [
                  Smartdown::Model::Rule.new(
                    Smartdown::Model::Predicate::Named.new("pred2?"),
                    "outcome"
                  )
                ]
              )
            ]
          )
        }
      end
    end

    describe "two rules nested" do
      let(:source) {
        [
          "* pred1?",
          "  * pred2? => outcome1",
          "  * pred3? => outcome2"
        ].join("\n")
      }
      let(:parsed_child1) { parser.parse("* pred2? => outcome1") }
      let(:parsed_child2) { parser.parse("* pred3? => outcome2") }

      it {
        should parse(source, trace: true).as(
          [
            {
              nested_rule: {
                predicate: { named_predicate: "pred1?" },
                child_rules: parsed_child1 + parsed_child2
              }
            }
          ]
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            [
              Smartdown::Model::NestedRule.new(
                Smartdown::Model::Predicate::Named.new("pred1?"),
                [
                  Smartdown::Model::Rule.new(
                    Smartdown::Model::Predicate::Named.new("pred2?"),
                    "outcome1"
                  ),
                  Smartdown::Model::Rule.new(
                    Smartdown::Model::Predicate::Named.new("pred3?"),
                    "outcome2"
                  )
                ]
              )
            ]
          )
        }
      end
    end

    describe "nesting and de-nesting" do
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  * pred2? => outcome1_2",
          "* pred3? => outcome3"
        ].join("\n")
      }
      let(:parsed_child_1) { parser.parse("* pred2? => outcome1_2") }
      let(:parsed_child_2) { parser.parse("* pred3? => outcome3").first }

      it {
        should parse(source).as(
          [
            {
              nested_rule: {
                predicate: { named_predicate: "pred1?" },
                child_rules: parsed_child_1
              }
            },
            parsed_child_2
          ]
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            [
              Smartdown::Model::NestedRule.new(
                Smartdown::Model::Predicate::Named.new("pred1?"),
                [
                  Smartdown::Model::Rule.new(
                    Smartdown::Model::Predicate::Named.new("pred2?"),
                    "outcome1_2"
                  )
                ]
              ),
              Smartdown::Model::Rule.new(
                Smartdown::Model::Predicate::Named.new("pred3?"),
                "outcome3"
              )
            ]
          )
        }
      end
    end

    describe "double nesting" do
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  * pred2?",
          "    " + child_rule
        ].join("\n")
      }
      let(:parsed_child_rule) { parser.parse(child_rule) }

      it {
        should parse(source, trace: true).as([
          {
            nested_rule: {
              predicate: {named_predicate: "pred1?"},
              child_rules: [
                nested_rule: {
                  predicate: {named_predicate: "pred2?"},
                  child_rules: parsed_child_rule
                }
              ]
            }
          }
        ])
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            [
              Smartdown::Model::NestedRule.new(
                Smartdown::Model::Predicate::Named.new("pred1?"),
                [
                  Smartdown::Model::NestedRule.new(
                    Smartdown::Model::Predicate::Named.new("pred2?"),
                    [
                      Smartdown::Model::Rule.new(
                        Smartdown::Model::Predicate::Named.new("pred2?"),
                        "outcome"
                      )
                    ]
                  )
                ]
              )
            ]
          )
        }
      end
    end

    describe "missing inner rule" do
      let(:source) { "* pred1?" }

      it { should_not parse(source) }
    end
  end
end

