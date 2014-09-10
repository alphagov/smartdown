require 'smartdown/parser/snippet_pre_parser'
require 'smartdown/parser/directory_input'
require 'ostruct'

describe Smartdown::Parser::SnippetPreParser do
  let(:input_data) {
    Smartdown::Parser::InputSet.new({
      coversheet: Smartdown::Parser::InputData.new("coversheet_1", "some smartdown {{coversheet_snippet}}"),
      questions: [
        Smartdown::Parser::InputData.new("question_1", "some {{question_snippet}} smartdown"),
      ],
      outcomes: [
        Smartdown::Parser::InputData.new("outcome_1", "some smartdown\n\n{{outcome_snippet}}\n\nmore smartdown"),
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
        coversheet: Smartdown::Parser::InputData.new("coversheet_1", "some smartdown {{top_level_snippet}}"),
        questions: [],
        outcomes: [],
        snippets: [
          Smartdown::Parser::InputData.new("top_level_snippet", "top level snippet {{nested_snippet}}"),
          Smartdown::Parser::InputData.new("nested_snippet", "nested snippet"),
        ],
        scenarios: []
      })
    }

    it "shoud recursively process nested snippets" do
      expect(parsed_output.coversheet.read).to eql "some smartdown top level snippet nested snippet"
    end
  end
end
