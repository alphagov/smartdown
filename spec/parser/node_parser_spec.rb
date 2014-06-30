require 'smartdown/parser/node_parser'

describe "parsing multiple choice nodes" do
  let(:parser) { Smartdown::Parser::NodeParser.new }

  def parse_and_rescue(source)
    begin
      parser.parse(source)
    rescue Parslet::ParseFailed => error
      raise error.cause.ascii_tree
    end
  end

  subject { parse_and_rescue(source) }

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
        body: [
          {h1: "This is my title\n"},
          {multiple_choice: [
            {value: "yes", label: "Yes"},
            {value: "no", label: "No"}
          ]}
        ]
      })
    end
  end
end
