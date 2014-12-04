require 'smartdown/api/outcome'
require 'smartdown/model/node'
require 'smartdown/model/front_matter'
require 'smartdown/model/element/next_steps'

describe Smartdown::Api::Outcome do

  subject(:outcome) { Smartdown::Api::Outcome.new(node) }

  let(:node_name) { 'node.js' }
  let(:front_matter) { Smartdown::Model::FrontMatter.new({}) }
  let(:node) { Smartdown::Model::Node.new(node_name, elements, front_matter) }

  let(:next_steps_content) { "discontentment" }
  let(:next_steps) { Smartdown::Model::Element::NextSteps.new(next_steps_content) }


  context "with next steps" do
    let(:elements) { [next_steps] }

    describe "#next_steps" do
      it "returns the content for next steps" do
        expect(outcome.next_steps).to eq(next_steps_content)
      end
    end
  end

  context "without next steps" do
    let(:elements) { [] }

    describe "#next_steps" do
      it "returns nil" do
        expect(outcome.next_steps).to eq(nil)
      end
    end
  end

end
