require 'smartdown/parser/rules'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Rules do
  subject(:parser) { described_class.new }
  let(:node_name) { "my_node" }

  describe "simple rule" do
    let(:source) { "* my_pred? => outcome" }

    it { should parse(source).as({next_node_rules: [{rule: {predicate: {named_predicate: "my_pred?"}, outcome: "outcome"}}]}) }
    it { should parse("* p? => q?").as({next_node_rules: [{rule: {predicate: {named_predicate: "p?"}, outcome: "q?"}}]}) }

    describe "transformed" do
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(
        Smartdown::Model::NextNodeRules.new(
          [
            Smartdown::Model::Rule.new(
              Smartdown::Model::Predicate::Named.new("my_pred?"),
              "outcome"
            )
          ]
        )
      ) }
    end
  end

  describe "nested rules" do
    describe "one inner rule" do
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  " + child_rule
        ].join("\n")
      }
      let(:parsed_child_rule) { parser.one_top_level_rule.parse(child_rule) }

      it { should parse(source).as(next_node_rules: [{nested_rule: {predicate: {named_predicate: "pred1?"}, child_rules: [parsed_child_rule]}}]) }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::NextNodeRules.new(
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
          )
        }
      end
    end

    describe "two inner rules" do
      let(:source) {
        [
          "* pred1?",
          "  * pred2? => outcome1",
          "  * pred3? => outcome2"
        ].join("\n")
      }
      let(:parsed_child1) { parser.one_top_level_rule.parse("* pred2? => outcome1") }
      let(:parsed_child2) { parser.one_top_level_rule.parse("* pred3? => outcome2") }

      it {
        should parse(source).as(
          next_node_rules: [
            {
              nested_rule: {
                predicate: { named_predicate: "pred1?" },
                child_rules: [parsed_child1, parsed_child2]
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
            Smartdown::Model::NextNodeRules.new(
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
          )
        }
      end
    end

    describe "combination of nested and non-nested rules" do
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  * pred2? => outcome1_2",
          "* pred3? => outcome3"
        ].join("\n")
      }
      let(:parsed_child_1) { parser.one_top_level_rule.parse("* pred2? => outcome1_2") }
      let(:parsed_child_2) { parser.one_top_level_rule.parse("* pred3? => outcome3") }

      it {
        should parse(source).as(
          next_node_rules: [
            {
              nested_rule: {
                predicate: { named_predicate: "pred1?" },
                child_rules: [parsed_child_1]
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
            Smartdown::Model::NextNodeRules.new(
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
          )
        }
      end
    end

    describe "nested rule in a nested rule" do
      let(:child_rule) { "* pred2? => outcome"}
      let(:source) {
        [
          "* pred1?",
          "  * pred2?",
          "    " + child_rule
        ].join("\n")
      }
      let(:parsed_child_rule) { parser.one_top_level_rule.parse(child_rule) }

      it {
        should parse(source, trace: true).as(
          next_node_rules: [
            {
              nested_rule: {
                predicate: {named_predicate: "pred1?"},
                child_rules: [
                  nested_rule: {
                    predicate: {named_predicate: "pred2?"},
                    child_rules: [parsed_child_rule]
                  }
                ]
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
            Smartdown::Model::NextNodeRules.new(
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

