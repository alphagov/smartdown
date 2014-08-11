require 'smartdown/parser/element/next_steps'
require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::Element::NextSteps do
  subject(:parser) { described_class.new }

  context "with next_steps tag" do
    let(:source) {
      [
        "[next_steps]",
        "* /some/url/destination: Next Step",
        "* /other/url_destination: Other Next Step"
      ].join("\n")
    }

    it "parses" do
      should parse(source).as(
        next_steps: {
          urls: [
            {url: "/some/url/destination", label: "Next Step"},
            {url: "/other/url_destination", label: "Other Next Step"}
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::NextSteps.new(
        {
          "/some/url/destination"=>"Next Step",
          "/other/url_destination"=>"Other Next Step"
        }
      )) }
    end
  end

  context "without next_steps tag" do
    let(:source) {
      [
        "* /some/url/destination: Next Step",
        "* /other/url_destination: Other Next Step"
      ].join("\n")
    }

    it "is not parsable" do
      should_not parse(source)
    end
  end
end
