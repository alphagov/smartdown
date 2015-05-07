require 'spec_helper'
require 'pathname'

RSpec.describe 'bin/smartdown' do
  let(:executable_path) {
    Pathname.new('../../bin/smartdown').expand_path(File.dirname(__FILE__))
  }

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  let(:input) { fixture("animal-example-simple") }

  before(:each) do
    @output = `LANG="en_GB.UTF-8" #{executable_path} "#{input}" #{responses} 2>&1`
    fail(raw_output) unless $?.success?
  end

  describe 'invocation with no response' do
    let(:responses) { "" }

    it "prints the cover page including RESPONSES and PATH" do
      expect(@output).to include("RESPONSES:")
      expect(@output).to include("PATH: animal-example-simple")
    end
  end

  describe 'invocation with single "y" response' do
    let(:responses) { "y" }

    it "prints the cover page including RESPONSES and PATH" do
      expect(@output).to include("RESPONSES: y")
      expect(@output).to include("PATH: animal-example-simple -> question_1")
      expect(@output).to include("What type of feline do you have?")
    end
  end

  describe 'invocation with single responses "y lion"' do
    let(:responses) { "y lion" }

    it "prints the cover page including RESPONSES and PATH" do
      expect(@output).to include("RESPONSES: y / lion")
      expect(@output).to include("PATH: animal-example-simple -> question_1 -> question_2")
      expect(@output).to include("Are you trained for lions?")
    end
  end

  describe 'invocation with single responses "y lion yes"' do
    let(:responses) { "y lion yes" }

    it "prints the outcome page including RESPONSES and PATH" do
      expect(@output).to include("RESPONSES: y / lion / yes")
      expect(@output).to include("PATH: animal-example-simple -> question_1 -> question_2 -> outcome_trained_with_lions")
      expect(@output).to include("You'll be alright, I think.")
    end
  end
end
