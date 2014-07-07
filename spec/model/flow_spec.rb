require 'smartdown/model/flow'
require 'smartdown/model/state'
require 'smartdown/model/node'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/question/multiple_choice'

describe Smartdown::Model::Flow do
  let(:coversheet) { instance_double("Smartdown::Model::Node", name: "my_name") }
  let(:nodes) { [] }
  subject(:flow) { Smartdown::Model::Flow.new(coversheet, nodes) }

  it "has a name" do
    expect(subject.name).to eq "my_name"
  end

  context "no nodes" do
    it "should have no nodes" do
      expect(flow.nodes).to eq([])
    end
  end

  context "one node" do
    let(:node_name) { "chocolate?" }
    let(:next_node_rules) { instance_double("Smartdown::Model::NextNodeRules") }
    let(:node) {
      instance_double("Smartdown::Model::Node", name: node_name, next_node_rules: next_node_rules)
    }
    let(:nodes) { [node] }

    describe "#nodes" do
      it "returns a list with the node" do
        expect(flow.nodes).to eq([node])
      end
    end

    describe "#node" do
      it "fetches the named node" do
        expect(subject.node(node_name)).to eq(node)
      end

      it "raises if node not found" do
        expect { subject.node("undefined node") }.to raise_error
      end
    end
  end
end
