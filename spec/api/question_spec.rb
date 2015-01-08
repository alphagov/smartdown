require 'smartdown/api/question'
require 'smartdown/api/date_question'
require 'smartdown/model/element/question/date'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_line'

describe Smartdown::Api::Question do

  subject(:question) { Smartdown::Api::Question.new(elements) }

  let(:question_element) {
    Smartdown::Model::Element::Question::Date.new(name, *args)
  }
  let(:aliaz) { nil }
  let(:args) { [start_year, end_year, aliaz] }
  let(:name)       { "a question" }
  let(:start_year) { nil }
  let(:end_year)   { nil }

  let(:heading_content) { "hehehe" }
  let(:heading) { Smartdown::Model::Element::MarkdownHeading}

  let(:body_content) { 'I <3 bodyshopping' }
  let(:body_element) {
    Smartdown::Model::Element::MarkdownLine.new(body_content)
  }

  let(:post_body_content) { 'hur hur such content' }
  let(:post_body_element) {
    Smartdown::Model::Element::MarkdownLine.new(post_body_content)
  }



  context "with a body and post_body" do
    let(:elements) { [heading, body_element, question_element, post_body_element] }

    describe "#body" do
      it 'returns the content before the question element' do
        expect(question.body).to eq(body_content)
      end
    end

    describe '#post_body' do
      it 'returns the content after the question element' do
        expect(question.post_body).to eq(post_body_content)
      end
    end
  end

  context "missing a body" do
    let(:elements) { [heading, question_element, post_body_element] }

    describe "#body" do
      it 'returns nil' do
        expect(question.body).to eq(nil)
      end
    end

    describe '#post_body' do
      it 'returns the content after the question element' do
        expect(question.post_body).to eq(post_body_content)
      end
    end
  end

  context "missing a post body" do
    let(:elements) { [heading, body_element, question_element] }

    describe "#body" do
      it 'returns the content before the question element' do
        expect(question.body).to eq(body_content)
      end
    end

    describe '#post_body' do
      it 'returns nil' do
        expect(question.post_body).to eq(nil)
      end
    end
  end

  context "missing a body and post body" do
    let(:elements) { [heading, question_element] }

    describe "#body" do
      it 'returns nil' do
        expect(question.body).to eq(nil)
      end
    end

    describe '#post_body' do
      it 'returns nil' do
        expect(question.post_body).to eq(nil)
      end
    end
  end

end
