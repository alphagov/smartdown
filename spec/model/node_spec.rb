require 'smartdown/model/node'

describe Smartdown::Model::Node do
  let(:name) { "my node" }
  let(:elements) { [] }

  describe "#new" do
    subject(:node) { described_class.new(name, elements) }

    it "accepts name and list of body blocks" do
      expect(node.name).to eq(name)
      expect(node.elements).to eq(elements)
    end

    context "no front matter" do
      let(:empty_front_matter) { Smartdown::Model::FrontMatter.new({}) }

      it "defaults to empty" do
        expect(node.front_matter).to eq(empty_front_matter)
      end
    end

    context "front matter" do
      let(:front_matter) { Smartdown::Model::FrontMatter.new({a: "1"}) }
      subject(:node) { described_class.new(name, elements, front_matter) }

      it "uses it" do
        expect(node.front_matter).to eq(front_matter)
      end
    end
  end
end
