require 'smartdown/model/node'

describe Smartdown::Model::Node do
  let(:name) { "my node" }
  let(:elements) { [] }
  subject(:node) { described_class.new(name, elements) }

  describe "#new" do

    it "accepts name and list of body blocks" do
      expect(node.name).to eq(name)
      expect(node.elements).to eq(elements)
    end

    context "no front matter" do
      let(:empty_front_matter) { Smartdown::Model::FrontMatter.new({}) }

      it "defaults to empty" do
        expect(node.front_matter).to eq(empty_front_matter)
      end
    end

    context "front matter" do
      let(:front_matter) { Smartdown::Model::FrontMatter.new({a: "1"}) }
      subject(:node) { described_class.new(name, elements, front_matter) }

      it "uses it" do
        expect(node.front_matter).to eq(front_matter)
      end
    end
  end

  describe "#questions" do
    context "with seval elements, some of which are questions" do
      let(:elements) { [
        Smartdown::Model::Element::MarkdownHeading.new("A Heading"),
        Smartdown::Model::Element::Question::Date.new("a_date_question"),
        Smartdown::Model::Element::Question::MultipleChoice.new("a_multiple_choice_question"),
        Smartdown::Model::Element::MarkdownParagraph.new("Some text"),
      ] }
      specify { expect(node.questions).to eq elements[1..2] }
    end
  end

  describe "#next_node_rules" do
    context "with elements, one of which is a NextNodeRules questions" do
      let(:elements) { [
        Smartdown::Model::Element::MarkdownHeading.new("A Heading"),
        Smartdown::Model::NextNodeRules.new(:rules)
      ] }
      specify { expect(node.next_node_rules).to eq elements[1] }
    end
  end

  describe "#start_button" do
    context "with elements, one of which is a StartButton questions" do
      let(:elements) { [
        Smartdown::Model::Element::StartButton.new(:a_start_node),
        Smartdown::Model::NextNodeRules.new(:rules)
      ] }
      specify { expect(node.start_button).to eq elements[0] }
    end
  end

  describe "#is_start_page_node?" do
    context "with a StartButton element" do
      let (:elements) { [Smartdown::Model::Element::StartButton.new(:some_start_node)] }
      specify { expect(node.is_start_page_node?).to eql true }
    end

    context "without a StartButton element" do
      let (:elements) { [] }
      specify { expect(node.is_start_page_node?).to eql false }
    end
  end
end
