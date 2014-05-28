require 'smartdown/node_parser'

describe "parsing multiple choice nodes" do
  let(:parser) { Smartdown::NodeParser.new }
  subject {
    begin
      parser.parse(source)
    rescue Parslet::ParseFailed => error
      raise error.cause.ascii_tree
    end
  }

  describe "simple empty multiple choice node" do
    let(:source) { "multiple_choice(my_node) {}" }

    it "extracts the question type and node name" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: ""
      })
    end
  end

  describe "title()" do
    let(:source) do
      %q{
        multiple_choice(my_node) {
          title("my title")
        }
      }
    end

    it "extracts the title" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "title",
            quoted_string: "my title"
          }
        ]
      })
    end
  end

  describe "hint()" do
    let(:source) do
      %q{
        multiple_choice(my_node) {
          hint("my hint
is spread over lines")
        }
      }
    end

    it "extracts the hint" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "hint",
            quoted_string: "my hint\nis spread over lines"
          }
        ]
      })
    end
  end

  describe "options {}" do
    let(:source) do
<<SOURCE
        multiple_choice(my_node) {
          options {
            no => No, thanks!
            yes => Yes, please!
          }
        }
SOURCE
    end

    it "extracts the options" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "options",
            options: [
              {
                name: "no",
                label: "No, thanks!"
              },
              {
                name: "yes",
                label: "Yes, please!"
              }
            ]
          }
        ]
      })
    end
  end

  describe "next_node with predefined predicate" do
    let(:source) do
<<SOURCE
    multiple_choice(my_node) {
      next_node {
        taiwan_or_venezuela? => outcome_visit_waiver
      }
    }
SOURCE
    end

    it "extracts the predicate name and outcome" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "next_node",
            rules: [
              {
                predicate: {
                  name: "taiwan_or_venezuela?"
                },
                next_node: "outcome_visit_waiver"
              }
            ]
          }
        ]
      })
    end
  end

  describe "next_node with parameterized predicate" do
    let(:source) do
<<SOURCE
    multiple_choice(my_node) {
      next_node {
        response(taiwan venezuela) => outcome_visit_waiver
      }
    }
SOURCE
    end

    it "extracts the predicate name and outcome" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "next_node",
            rules: [
              {
                predicate: {
                  name: "response",
                  parameters: [{string: "taiwan"}, {string: "venezuela"}]
                },
                next_node: "outcome_visit_waiver"
              }
            ]
          }
        ]
      })
    end
  end

  describe "next_node with nested predicate" do
    let(:source) do
<<SOURCE
    multiple_choice(my_node) {
      next_node {
        response(taiwan) {
          visa_national? => outcome_visit_waiver
        }
      }
    }
SOURCE
    end

    it "extracts the predicate name and outcome" do
      should eq({
        question_type: "multiple_choice",
        question_name: "my_node",
        commands: [
          {
            name: "next_node",
            rules: [
              {
                nested: {
                  predicate: {
                    name: "response",
                    parameters: [{string: "taiwan"}]
                  },
                  rules: [
                    {
                      predicate: {
                        name: "visa_national?",
                      },
                      next_node: "outcome_visit_waiver"
                    }
                  ]
                }
              }
            ]
          }
        ]
      })
    end
  end
end
