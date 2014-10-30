require 'smartdown/api/flow'

describe Smartdown::Api::Flow do

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  let(:input) { Smartdown::Parser::DirectoryInput.new(fixture("animal-example-simple")) }
  subject(:flow) { Smartdown::Api::Flow.new(input) }

  context "flow with one question per page" do
    it "has two scenario_sets" do
      expect(flow.scenario_sets.size).to eq(2)
    end

    it "has scenario_set names" do
      expect(flow.scenario_sets.map(&:name)).to match_array(["lions", "tigers_and_cats"])
    end

    it "has scenarios with description, questions and outcome" do
      tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
      expect(tigers_and_cats_scenario_set.scenarios.size).to eq(1)
      expect(tigers_and_cats_scenario_set.scenarios.first.description).to eq("User has a cat;And cats are amazing")
      expect(tigers_and_cats_scenario_set.scenarios.first.question_groups.size).to eq(1)
      expect(tigers_and_cats_scenario_set.scenarios.first.outcome).to eq("outcome_safe_pet")
    end

    it "has scenario questions with name and answer" do
      tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "tigers_and_cats" }
      tigers_and_cats_scenario = tigers_and_cats_scenario_set.scenarios.first
      expect(tigers_and_cats_scenario.question_groups.first.first.name).to eq("question_1")
      expect(tigers_and_cats_scenario.question_groups.first.first.answer).to eq("cat")
    end

    context "flow state" do
      context "with no answers given" do
        specify { expect(flow.state("y",[]).current_answers).to be_empty }
        specify { expect(flow.state("y",[]).accepted_responses).to eq [] }
      end

      context "with a valid answer given to the first question" do
        specify { expect(flow.state("y",["cat"]).current_node.name).to eq "outcome_safe_pet" }
        specify { expect(flow.state("y",["cat"]).accepted_responses).to eq ["cat"] }
        specify { expect(flow.state("y",["cat"]).current_answers).to eq [] }
      end

      context "with an invalid answer given to the first question" do
        specify { expect(flow.state("y",["lynx"]).current_node.name).to eq "question_1" }
        specify { expect(flow.state("y",["lynx"]).accepted_responses).to eq [] }
        specify { expect(flow.state("y",["lynx"]).current_answers.first.error).to eq "Invalid choice" }
      end
    end

  end

  context "flow with two questions per page" do
    let(:input) { Smartdown::Parser::DirectoryInput.new(fixture("animal-example-multiple")) }
    it "has two scenario_sets" do
      expect(flow.scenario_sets.size).to eq(2)
    end

    it "has scenario_set names" do
      expect(flow.scenario_sets.map(&:name)).to match_array(["lions", "tigers_and_cats"])
    end

    it "has scenarios with description, questions and outcome" do
      tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "lions" }
      expect(tigers_and_cats_scenario_set.scenarios.size).to eq(4)
      expect(tigers_and_cats_scenario_set.scenarios.first.description).to eq("User has trained with lions, not with tigers")
      expect(tigers_and_cats_scenario_set.scenarios.first.question_groups.size).to eq(2)
      expect(tigers_and_cats_scenario_set.scenarios.first.outcome).to eq("outcome_trained_with_lions")
    end

    it "has scenario questions with name and answer" do
      tigers_and_cats_scenario_set = flow.scenario_sets.find { |scenario_set| scenario_set.name == "lions" }
      tigers_and_cats_scenario = tigers_and_cats_scenario_set.scenarios.first
      expect(tigers_and_cats_scenario.question_groups[1][0].name).to eq("trained_for_lions")
      expect(tigers_and_cats_scenario.question_groups[1][0].answer).to eq("yes")
      expect(tigers_and_cats_scenario.question_groups[1][1].name).to eq("trained_for_tigers")
      expect(tigers_and_cats_scenario.question_groups[1][1].answer).to eq("no")
    end

    context "flow state" do
      context "with no answers given" do
        specify { expect(flow.state("y",[]).current_answers).to be_empty }
      end

      context "with a valid answer given to the first question, only first answer to second page" do
        specify { expect(flow.state("y",["lion", "yes", nil]).current_node.name).to eq "question_2" }
        specify { expect(flow.state("y",["lion", "yes", nil]).accepted_responses).to eq ["lion"] }
        specify { expect(flow.state("y",["lion", "yes", nil]).current_answers.count).to eq 2 }
        specify { expect(flow.state("y",["lion", "yes", nil]).current_answers[0].valid?).to be true }
        specify { expect(flow.state("y",["lion", "yes", nil]).current_answers[1].error).to eq "Please answer this question" }
      end

      context "with a valid answer given to the first question, only second answer to second page" do
        specify { expect(flow.state("y",["lion", nil, "yes"]).current_node.name).to eq "question_2" }
        specify { expect(flow.state("y",["lion", nil, "yes"]).accepted_responses).to eq ["lion"] }
        specify { expect(flow.state("y",["lion", nil, "yes"]).current_answers.count).to eq 2 }
        specify { expect(flow.state("y",["lion", nil, "yes"]).current_answers[1].valid?).to be true }
        specify { expect(flow.state("y",["lion", nil, "yes"]).current_answers[0].error).to eq "Please answer this question" }
      end

      context "with a valid answer given to the first question, only first invalid answer to second page" do
        specify { expect(flow.state("y",["lion", "lynx", nil]).current_node.name).to eq "question_2" }
        specify { expect(flow.state("y",["lion", "lynx", nil]).accepted_responses).to eq ["lion"] }
        specify { expect(flow.state("y",["lion", "lynx", nil]).current_answers.count).to eq 2 }
        specify { expect(flow.state("y",["lion", "lynx", nil]).current_answers[0].error).to eq "Invalid choice" }
        specify { expect(flow.state("y",["lion", "lynx", nil]).current_answers[1].error).to eq "Please answer this question" }
      end

      context "with a valid answer given to the first question, empty answers to second page" do
        specify { expect(flow.state("y",["lion", nil, nil]).current_node.name).to eq "question_2" }
        specify { expect(flow.state("y",["lion", nil, nil]).accepted_responses).to eq ["lion"] }
        specify { expect(flow.state("y",["lion", nil, nil]).current_answers.count).to eq 2 }
        specify { expect(flow.state("y",["lion", nil, nil]).current_answers[0].error).to eq "Please answer this question" }
        specify { expect(flow.state("y",["lion", nil, nil]).current_answers[1].error).to eq "Please answer this question" }
      end

      context "with valid answers to both pages" do
        specify { expect(flow.state("y",["lion", "no", "no"]).current_node.name).to eq "outcome_untrained_with_lions" }
        specify { expect(flow.state("y",["lion", "no", "no"]).accepted_responses).to eq ["lion", "no", "no"] }
        specify { expect(flow.state("y",["lion", "no", "no"]).current_answers).to eq [] }
      end
    end
  end

end


