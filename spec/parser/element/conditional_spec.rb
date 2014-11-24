require 'smartdown/parser/element/conditional'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::Conditional do

  subject(:parser) { described_class.new }
  let(:node_name) { "my_node" }

  context "simple IF" do
    let(:source) { <<-SOURCE
$IF pred1?

#{true_body}

$ENDIF
SOURCE
    }

    context "with one-line true case" do
      let(:true_body) { "Text if true" }

      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{true_body}\n"}]
          }
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?"),
              [Smartdown::Model::Element::MarkdownParagraph.new(true_body + "\n")]
            )
          )
        }
      end

    end

    context "with multi-line true case" do
      let(:one_line) { "Text if true" }
      let(:true_body) { "#{one_line}\n\n#{one_line}" }

      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{one_line}\n"}, {p: "#{one_line}\n"}]
          }
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?"),
              [
                Smartdown::Model::Element::MarkdownParagraph.new(one_line + "\n"),
                Smartdown::Model::Element::MarkdownParagraph.new(one_line + "\n")
              ]
            )
          )
        }
      end
    end

    context "with empty true case case" do
      let(:true_body) { "" }

      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"}
          }
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?")
            )
          )
        }
      end
    end

  context "simple IF-ELSE" do
    let(:source) { <<-SOURCE
$IF pred1?

#{true_body}

$ELSE

#{false_body}

$ENDIF
SOURCE
    }

    context "with one-line true case" do
      let(:true_body) { "Text if true" }
      let(:false_body) { "Text if false" }

      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{true_body}\n"}],
            false_case: [{p: "#{false_body}\n"}]
          }
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?"),
              [Smartdown::Model::Element::MarkdownParagraph.new(true_body + "\n")],
              [Smartdown::Model::Element::MarkdownParagraph.new(false_body + "\n")]
            )
          )
        }
      end
    end
  end

  context "simple ELSE-IF" do
    let(:source) { <<-SOURCE
$IF pred1?

#{true1_body}

$ELSEIF pred2?

#{true2_body}

$ENDIF
SOURCE
    }

    context "with one-line true case" do
      let(:true1_body) { "Text if first predicate is true" }
      let(:true2_body) { "Text if first predicate is false and the second is true" }


      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{true1_body}\n"}],
            false_case: [{conditional: {
              predicate: {named_predicate: "pred2?"},
              true_case: [{p: "#{true2_body}\n"}],
            }}]
          }
        )
      }

        describe "transformed" do
          subject(:transformed) {
            Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
          }

          it {
            should eq(
              Smartdown::Model::Element::Conditional.new(
                Smartdown::Model::Predicate::Named.new("pred1?"),
                [Smartdown::Model::Element::MarkdownParagraph.new(true1_body + "\n")],
                [Smartdown::Model::Element::Conditional.new(
                  Smartdown::Model::Predicate::Named.new("pred2?"),
                  [Smartdown::Model::Element::MarkdownParagraph.new(true2_body + "\n")]
                )]
              )
            )
          }
        end
      end
    end
  end

  context "double ELSE-IF" do
    let(:source) { <<-SOURCE
$IF pred1?

#{true1_body}

$ELSEIF pred2?

#{true2_body}

$ELSEIF pred3?

#{true3_body}

$ENDIF
SOURCE
    }

    context "with one-line true case" do
      let(:true1_body) { "Text if first predicate is true" }
      let(:true2_body) { "Text if first predicate is false and the second is true" }
      let(:true3_body) { "Text if first and second predicates are false and the third is true" }

      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{true1_body}\n"}],
            false_case: [{conditional: {
              predicate: {named_predicate: "pred2?"},
              true_case: [{p: "#{true2_body}\n"}],
              false_case: [{conditional: {
                predicate: {named_predicate: "pred3?"},
                true_case: [{p: "#{true3_body}\n"}],
              }}]
            }}]
          }
        )
      }

      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?"),
              [Smartdown::Model::Element::MarkdownParagraph.new(true1_body + "\n")],
              [Smartdown::Model::Element::Conditional.new(
                Smartdown::Model::Predicate::Named.new("pred2?"),
                [Smartdown::Model::Element::MarkdownParagraph.new(true2_body + "\n")],
                  [Smartdown::Model::Element::Conditional.new(
                    Smartdown::Model::Predicate::Named.new("pred3?"),
                    [Smartdown::Model::Element::MarkdownParagraph.new(true3_body + "\n")]
                  )]
              )]
            )
          )
        }
      end
    end
  end

  context "ELSE-IF with an ELSE" do
    let(:source) { <<-SOURCE
$IF pred1?

#{true1_body}

$ELSEIF pred2?

#{true2_body}

$ELSE

#{false_body}

$ENDIF
SOURCE
    }

    context "with one-line true case" do
      let(:true1_body) { "Text if first predicate is true" }
      let(:true2_body) { "Text if first predicate is false and the second is true" }
      let(:false_body) { "Text both predicates are false" }


      it {
        should parse(source).as(
          conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [{p: "#{true1_body}\n"}],
            false_case: [{conditional: {
              predicate: {named_predicate: "pred2?"},
              true_case: [{p: "#{true2_body}\n"}],
              false_case: [{p: "#{false_body}\n"}]
            }}]
          }
        )
      }


      describe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it {
          should eq(
            Smartdown::Model::Element::Conditional.new(
              Smartdown::Model::Predicate::Named.new("pred1?"),
              [Smartdown::Model::Element::MarkdownParagraph.new(true1_body + "\n")],
              [Smartdown::Model::Element::Conditional.new(
                Smartdown::Model::Predicate::Named.new("pred2?"),
                [Smartdown::Model::Element::MarkdownParagraph.new(true2_body + "\n")],
                [Smartdown::Model::Element::MarkdownParagraph.new(false_body + "\n")]
              )]
            )
          )
        }
      end

    end
  end

  context "Nested IF statement" do
    let(:source) { <<-SOURCE
$IF pred1?

#{first_true_body}

$IF pred2?

#{both_true_body}

$ENDIF

#{first_true_body}

$ENDIF
SOURCE
}
    context "With a body for double true case" do
      let(:first_true_body) { "Text if first predicates is true" }
      let(:both_true_body) { "Text if both predicates are true" }
      it { should parse(source).as(
           conditional: {
             predicate: {named_predicate: "pred1?"},
             true_case: [
               {p: "#{first_true_body}\n"},
               {conditional: {
                 predicate: {named_predicate: "pred2?"},
                 true_case: [{p: "#{both_true_body}\n"}],
               }},
               {p: "#{first_true_body}\n"}
             ]
           }
        )
      }
    end
  end

  context "with custom markdown tags inside" do

    let (:source) { <<-SOURCE
$IF pred?

#{true_body.chomp}

$ENDIF
SOURCE
}
    let(:true_body) { <<-TAG
$E
Bit of content in lovely custom tag
$E
TAG
}

    it { should parse(source).as(
         conditional: {
           predicate: {named_predicate: "pred?"},
            true_case: [
              {p: "#{true_body}"}
           ]},
        )
      }
  end
end

