require 'smartdown/parser/directory_input'
require 'support/flow_input_interface'

describe Smartdown::Parser::DirectoryInput do
  it_should_behave_like "flow input interface"

  let(:coversheet_file) {
    Pathname.new("../../fixtures/directory_input/cover-sheet.txt").expand_path(__FILE__)
  }

  subject(:input) { described_class.new(coversheet_file) }

  describe "#coversheet" do
    subject { input.coversheet }

    it { should be_a(Smartdown::Parser::InputFile) }

    it "has name" do
      expect(input.coversheet.name).to eq("cover-sheet")
    end

    it "reads the file contents" do
      expect(input.coversheet.read).to eq("cover sheet\n")
    end
  end

  describe "#questions" do
    it "returns an InputFile for every file in the questions folder" do
      expect(input.questions).to match([instance_of(Smartdown::Parser::InputFile)])
      expect(input.questions.first.name).to eq("q1")
      expect(input.questions.first.read).to eq("question one\n")
    end
  end

  describe "#outcomes" do
    it "returns an InputFile for every file in the outcomes folder to arbitrary sub directory depth" do
      expect(input.outcomes).to match([
        instance_of(Smartdown::Parser::InputFile),
        instance_of(Smartdown::Parser::InputFile),
      ])

      expect(input.outcomes.map(&:name)).
        to match_array(["o1", "nested/o1",])

      expect(input.outcomes.map(&:read)).
      to match_array(["outcome one\n", "nested outcome\n"])
    end
  end

  describe "#scenario_sets" do
    it "returns an InputFile for every file in the scenarios folder" do
      expect(input.scenario_sets).to match([instance_of(Smartdown::Parser::InputFile)])
      expect(input.scenario_sets.first.name).to eq("s1")
      expect(input.scenario_sets.first.read).to eq("scenario one\n")
    end
  end

  describe "#snippets" do
    it "returns an InputFile for every file in the snippets folder to arbitrary sub directory depth" do
      expect(input.snippets).to match([
        instance_of(Smartdown::Parser::InputFile),
        instance_of(Smartdown::Parser::InputFile),
      ])

      expect(input.snippets.map(&:name)).
        to match_array(["sn1", "nested/nested_again/nsn1"])

      expect(input.snippets.map(&:read)).
        to match_array(["snippet one\n", "nested snippet\n"])
    end
  end
end
