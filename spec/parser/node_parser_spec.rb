require 'smartdown/parser/node_parser'

describe "parsing multiple choice nodes" do
  let(:parser) { Smartdown::Parser::NodeParser.new }

  subject {
    begin
      parser.parse(source)
    rescue Parslet::ParseFailed => error
      raise error.cause.ascii_tree
    end
  }

  describe "front matter only" do
    let(:source) {
      <<-SOURCE.gsub(/^ */, '')
        name: What country are you from?
        country_exclusions: england ireland scotland wales
        colour: red
      SOURCE
    }

    it "extracts it" do
      should eq({
        front_matter: [
          {
            name: 'name',
            value: 'What country are you from?'
          },
          {
            name: 'country_exclusions',
            value: 'england ireland scotland wales'
          },
          {
            name: 'colour',
            value: 'red'
          }
        ]
      })
    end
  end

  describe "body only" do
    let(:source) {
<<SOURCE
# This is my title

This is a paragraph of text with stuff
that flows along

Another paragraph of text
SOURCE
     }

    it "extracts it" do
      should eq({
        body: [
          {h1: "This is my title\n"},
          {p: "This is a paragraph of text with stuff\nthat flows along\n"},
          {p: "Another paragraph of text\n"}
        ]
      })
    end
  end

  describe "front matter and body" do
    let(:source) {
<<SOURCE
name: My node

# This is my title

A paragraph
SOURCE
     }

    it "extracts it" do
      should eq({
        front_matter: [
          {name: "name", value: "My node"}
        ],
        body: [
          {h1: "This is my title\n"},
          {p: "A paragraph\n"}
        ]
      })
    end
  end

  describe "body with multiple choice options" do
    let(:source) {
<<SOURCE
# This is my title

* yes: Yes
* no: No
SOURCE
     }

    it "extracts it" do
      should eq({
        body: {h1: "This is my title\n"},
        multiple_choice: [
          {value: "yes", label: "Yes"},
          {value: "no", label: "No"}
        ]
      })
    end
  end
end
