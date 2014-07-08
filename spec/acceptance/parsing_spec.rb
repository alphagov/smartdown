require 'smartdown.rb'

describe "Smartdown.parse" do

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  context "flow with only a cover-sheet" do
    subject(:flow) { Smartdown.parse(fixture("cover-sheet")) }

    it "should build a Flow model" do
      expect(flow).to be_a(Smartdown::Model::Flow)
    end

    it "should derive the name from the filename" do
      expect(flow.name).to eq("cover-sheet")
    end

    it "should have a single coversheet node" do
      expect(flow.nodes).to match([instance_of(Smartdown::Model::Node)])
    end

    describe "#coversheet" do
      subject(:coversheet) { flow.coversheet }

      it "should return the coversheet node" do
        expect(flow.coversheet).to be_a(Smartdown::Model::Node)
      end

      it "should have front matter" do
        expect(coversheet.front_matter).to be_a(Smartdown::Model::FrontMatter)
      end

      describe "front matter" do
        it "should have satisfies_need" do
          expect(coversheet.front_matter.satisfies_need).to eq("1234")
        end

        it "should have meta_description" do
          expect(coversheet.front_matter.meta_description).to eq("Blah blah")
        end
      end

      it "should have a title extracted from the first markdown H1" do
        expect(coversheet.title).to eq("My coversheet")
      end

      it "should have a body" do
        expect(coversheet.body).to eq(<<-EXPECTED)
This is the body markdown.

It has many paragraphs
of text.

* it
* can
* have
* lists
EXPECTED
      end

      xit "should have next node rules derived from the start_question" do
      end
    end
  end

  context "flow with a cover-sheet and a question" do
    subject(:flow) { Smartdown.parse(fixture("one-question")) }

    it "should have two nodes" do
      expect(flow.nodes.size).to eq(2)
      expect(flow.nodes[0]).to eq(flow.coversheet)
      expect(flow.nodes[1]).to be_a(Smartdown::Model::Node)
    end

    describe "the question node" do
      subject(:question_node) { flow.nodes[1] }

      it "should have title" do
        expect(question_node.title).to eq("Question one")
      end

      it "should have two body paras" do
        expect(question_node.body).to eq(<<-EXPECTED)
Body text line 1.

Body text
para 2.
EXPECTED
      end

      it "should have a multiple choice question" do
        expect(question_node.questions).to match([instance_of(Smartdown::Model::Element::MultipleChoice)])
      end
    end
  end
end


