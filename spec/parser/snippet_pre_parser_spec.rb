require 'smartdown/parser/snippet_pre_parser'
require 'smartdown/parser/directory_input'
require 'ostruct'

describe Smartdown::Parser::SnippetPreParser do
  let(:input_data) {
    Smartdown::Parser::InputSet.new({
      coversheet: Smartdown::Parser::InputData.new("coversheet_1", "some smartdown {{snippet: coversheet_snippet}}"),
      questions: [
        Smartdown::Parser::InputData.new("question_1", "some {{snippet: question_snippet}} smartdown"),
      ],
      outcomes: [
        Smartdown::Parser::InputData.new("outcome_1", "some smartdown\n\n{{snippet: outcome_snippet}}\n\nmore smartdown"),
      ],
      snippets: [
        Smartdown::Parser::InputData.new("question_snippet", "question snippet"),
        Smartdown::Parser::InputData.new("outcome_snippet", "outcome snippet"),
        Smartdown::Parser::InputData.new("coversheet_snippet", "coversheet snippet"),
      ],
      scenarios: [:some_scenario]
    })
  }

  subject(:parsed_output) {
    described_class.parse(input_data)
  }

  it "should replace the snippet tag with the snippet content for questions" do
    expect(parsed_output.questions[0].read).to eql "some question snippet smartdown"
  end

  it "should replace the snippet tag with the snippet content for outcomes" do
    expect(parsed_output.outcomes[0].read).to eql "some smartdown\n\noutcome snippet\n\nmore smartdown"
  end

  it "should replace the snippet tag with the snippet content for the coversheet" do
    expect(parsed_output.coversheet.read).to eql "some smartdown coversheet snippet"
  end

  context "with nested snippets" do
    let(:input_data) {
      Smartdown::Parser::InputSet.new({
        coversheet: Smartdown::Parser::InputData.new("coversheet_1", "some smartdown {{snippet: top_level_snippet}}"),
        questions: [],
        outcomes: [],
        snippets: [
          Smartdown::Parser::InputData.new("top_level_snippet", "top level snippet {{snippet: nested_snippet}}"),
          Smartdown::Parser::InputData.new("nested_snippet", "nested snippet"),
        ],
        scenarios: []
      })
    }

    it "shoud recursively process nested snippets" do
      expect(parsed_output.coversheet.read).to eql "some smartdown top level snippet nested snippet"
    end
  end

  context "when referencing a non-existent snippet" do
    let(:input_data) {
      Smartdown::Parser::InputSet.new({
        coversheet: Smartdown::Parser::InputData.new("coversheet_1", "some smartdown {{snippet: non_existent_snippet}}"),
        questions: [],
        outcomes: [],
        snippets: [],
        scenarios: []
      })
    }

    specify { expect { parsed_output }.to raise_exception(Smartdown::Parser::SnippetPreParser::SnippetNotFound) }
  end

  describe "whitespace handling" do
    let(:snippet_smartdown) { "A snippet" }
    let(:input_data) {
      Smartdown::Parser::InputSet.new({
        coversheet: Smartdown::Parser::InputData.new("coversheet_1",  "Smartdown {{snippet: snippet}} more smartdown"),
        questions: [],
        outcomes: [],
        snippets: [ Smartdown::Parser::InputData.new("snippet", snippet_smartdown) ],
        scenarios: []
      })
    }

    context "when snippet smartdown has leading / trailing whitespace" do
      let(:snippet_smartdown) { "\n\n  Snippet text\n\n with whitespace  \n\n" }

      it "should strip off the snippet content's leading and trailing whitespace" do
        expect(parsed_output.coversheet.read).to eql "Smartdown Snippet text\n\n with whitespace more smartdown"
      end
    end
  end

  describe "alternative tag definitions" do
    let(:snippet_tag) { "{{snippet: snippet_name}}" }
    let(:input_data) {
      Smartdown::Parser::InputSet.new({
        coversheet: Smartdown::Parser::InputData.new("coversheet_1",  snippet_tag),
        questions: [],
        outcomes: [],
        snippets: [ Smartdown::Parser::InputData.new("snippet_name", "the snippet") ],
        scenarios: []
      })
    }

    context "with {{SNIPPET: snippet_name}}" do
      let(:snippet_tag) { "{{SNIPPET: snippet_name}}" }
      specify { expect(parsed_output.coversheet.read).to eql "the snippet" }
    end

    context "with {{snippet:snippet_name}}" do
      let(:snippet_tag) { "{{snippet:snippet_name}}" }
      specify { expect(parsed_output.coversheet.read).to eql "the snippet" }
    end
  end
end
