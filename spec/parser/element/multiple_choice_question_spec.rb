require 'smartdown/parser/element/start_button'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::MultipleChoiceQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) {
      [
        "[choice: yes_or_no]",
        "* yes: Yes",
        "* no: No"
      ].join("\n")
    }

    it "parses" do
      should parse(source).as(
        multiple_choice: {
          identifier: "yes_or_no",
          options: [
            {value: "yes", label: "Yes"},
            {value: "no", label: "No"}
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::MultipleChoice.new("yes_or_no", {"yes"=>"Yes", "no"=>"No"})) }
    end
  end

  context "with a hint" do
    let(:source) {
      [
        "[choice: yes_or_no]",
        "[hint: Hint sentence.]",
        "* yes: Yes",
        "* no: No"
      ].join("\n")
    }

    it "parses" do
      should parse(source).as(
                 multiple_choice: {
                     identifier: "yes_or_no",
                     hint: "Hint sentence.",
                     options: [
                         {value: "yes", label: "Yes"},
                         {value: "no", label: "No"}
                     ]
                 }
             )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::MultipleChoice.new(
        "yes_or_no",
        {"yes"=>"Yes", "no"=>"No"},
        "Hint sentence."
      )) }
    end
  end

  context "without question tag" do
    let(:source) {
      [
        "* yes: Yes",
        "* no: No"
      ].join("\n")
    }

    it "is not parsable" do
      should_not parse(source)
    end
  end
end
