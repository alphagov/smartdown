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
    %{ Rule 1: Do not talk about Fight Club.
       Rule 2: Do not talk about Fight Club.
       Rule 3: If someone says "stop" or goes limp, taps out the fight is over.
       Rule 4: Only two guys to a fight.
       Rule 5: One fight at a time.
       Rule 6: No shirts, no shoes.
       Rule 7: Fights will go on as long as they have to.
       Rule 8: If this is your first night at Fight Club, you have to fight.} }
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

  let(:question_heading_content) { "Do you feel lucky?" }
  let(:question_heading) { Smartdown::Model::Element::MarkdownHeading.new(question_heading_content) }

  let(:body_content) { "I <3 bodyshopping" }
  let(:body_elements) {
    Smartdown::Model::Elements.new(
      [
        Smartdown::Model::Element::MarkdownLine.new(body_content),
        Smartdown::Model::Element::MarkdownLine.new("\n")
      ]
    )
  }

  let(:post_body_content) { "hur hur such content" }
  let(:post_body_elements) {
    Smartdown::Model::Elements.new(
      [Smartdown::Model::Element::MarkdownLine.new(post_body_content)]
    )
  }

  let(:other_post_body_content) { "Postman Pat and his black and white cat" }
  let(:other_post_body_elements) {
    Smartdown::Model::Elements.new(
      [
        Smartdown::Model::Element::MarkdownLine.new("\n"),
        Smartdown::Model::Element::MarkdownLine.new(other_post_body_content)
      ]
    )
  }


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

end
