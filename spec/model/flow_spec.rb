require 'smartdown/model/flow'
require 'smartdown/model/node'

describe Smartdown::Model::Flow do
  let(:flow_name) { "my_name" }
  let(:nodes) { [] }
  subject(:flow) { Smartdown::Model::Flow.new(flow_name, nodes) }

  it "has a name" do
    expect(subject.name).to eq(flow_name)
  end

  context "no nodes" do
    it "has no nodes" do
      expect(flow.nodes).to eq([])
    end
  end

  context "one node" do
    let(:node_name) { "chocolate?" }
    let(:node) {
      instance_double("Smartdown::Model::Node", name: node_name)
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
