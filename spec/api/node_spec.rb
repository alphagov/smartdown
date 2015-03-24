require 'smartdown/api/node'
require 'smartdown/api/question'
require 'smartdown/api/date_question'
require 'smartdown/model/node'
require 'smartdown/model/front_matter'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/element/question/date'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_line'

describe Smartdown::Api::Node do

  subject(:node) { Smartdown::Api::Node.new(node_model) }

  let(:node_name) { "New Oxford Dictionary of English" }
  let(:front_matter) { Smartdown::Model::FrontMatter.new({}) }
  let(:node_model) { Smartdown::Model::Node.new(node_name, elements, front_matter) }

  let(:next_node_rules_content) {
    %{ Rule 1: Is a rule
       Rule 2: Is another rule }
  }

  let(:next_node_rules) { Smartdown::Model::NextNodeRules.new(next_node_rules_content) }

  let(:question_element) {
    Smartdown::Model::Element::Question::Date.new(name, *args)
  }
  let(:aliaz) { nil }
  let(:args) { [start_year, end_year, aliaz] }
  let(:name)       { "a question" }
  let(:start_year) { nil }
  let(:end_year)   { nil }

  let(:node_heading_content) { "hehehe" }
  let(:node_heading) { Smartdown::Model::Element::MarkdownHeading.new(node_heading_content) }

  let(:question_heading_content) { "Is this a question?" }
  let(:question_heading) { Smartdown::Model::Element::MarkdownHeading.new(question_heading_content) }

  let(:body_content) { "Body" }
  let(:body_elements) {
    Smartdown::Model::Elements.new(
      [
        Smartdown::Model::Element::MarkdownLine.new(body_content),
        Smartdown::Model::Element::MarkdownLine.new("\n")
      ]
    )
  }

  let(:post_body_content) { "content" }
  let(:post_body_elements) {
    Smartdown::Model::Elements.new(
      [Smartdown::Model::Element::MarkdownLine.new(post_body_content)]
    )
  }

  let(:other_post_body_content) { "Post Body Content" }
  let(:other_post_body_elements) {
    Smartdown::Model::Elements.new(
      [
        Smartdown::Model::Element::MarkdownLine.new("\n"),
        Smartdown::Model::Element::MarkdownLine.new(other_post_body_content)
      ]
    )
  }

  let(:marker) { Smartdown::Model::Element::Marker.new("Content Marker") }

  context "with a body and post_body (and next node rules)" do
    let(:elements) { [node_heading, body_elements, question_heading, question_element, post_body_elements, other_post_body_elements, next_node_rules] }

    describe "#body" do
      it 'returns the content before the question element' do
        body =  [body_content, question_heading_content].join("\n")
        expect(node.body).to eq(body)
      end
    end

    describe '#post_body' do
      it 'returns the content after the question element' do
        post_body =  [post_body_content, other_post_body_content].join("\n")
        expect(node.post_body).to eq(post_body)
      end
    end
  end

  context "missing a body" do
    let(:elements) { [question_element, post_body_elements] }

    describe "#body" do
      it 'returns nil' do
        expect(node.body).to eq(nil)
      end
    end

    describe '#post_body' do
      it 'returns the content after the question element' do
        expect(node.post_body).to eq(post_body_content)
      end
    end
  end

  context "missing a post body" do
    let(:elements) { [node_heading, body_elements, question_heading, question_element] }

    describe "#body" do
      it 'returns the content before the question element' do
        body =  [body_content, question_heading_content].join("\n")
        expect(node.body).to eq(body)
      end
    end

    describe '#post_body' do
      it 'returns nil' do
        expect(node.post_body).to eq(nil)
      end
    end
  end

  context "missing a body and post body" do
    let(:elements) { [question_element] }

    describe "#body" do
      it 'returns nil' do
        expect(node.body).to eq(nil)
      end
    end

    describe '#post_body' do
      it 'returns nil' do
        expect(node.post_body).to eq(nil)
      end
    end
  end

  context "without next node rules" do
    let(:elements) { [node_heading, question_heading, question_element] }

    describe "#next_nodes" do
      it 'returns an empty list' do
        expect(node.next_nodes).to eq([])
      end
    end
  end

  context "with next node rules" do
    let(:elements) { [node_heading, question_heading, question_element, next_node_rules] }

    describe "#next_nodes" do
      it 'returns the next node rules in a list' do
        expect(node.next_nodes).to eq([next_node_rules])
      end
    end
  end

  context "with a marker" do
    let(:elements) { [node_heading, question_heading, question_element, marker] }

    describe "#markers" do
      it 'returns the markers' do
        expect(node.markers).to eq([Smartdown::Model::Element::Marker.new("Content Marker")])
      end
    end
  end

end
