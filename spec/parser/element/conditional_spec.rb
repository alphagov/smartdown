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

      xdescribe "transformed" do
        subject(:transformed) {
          Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
        }

        it { should eq(Smartdown::Model::Element::MarkdownParagraph.new(content)) }
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
    end
  end

end

