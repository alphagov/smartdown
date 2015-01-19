require 'smartdown.rb'

describe "Smartdown.parse" do

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  context "flow with only a cover-sheet" do
    subject(:flow) { Smartdown.parse(fixture("cover-sheet")) }

    it "builds a Flow model" do
      expect(flow).to be_a(Smartdown::Model::Flow)
    end

    it "derives the name from the filename" do
      expect(flow.name).to eq("cover-sheet")
    end

    it "has a single coversheet node" do
      expect(flow.nodes).to match([instance_of(Smartdown::Model::Node)])
    end

    describe "#coversheet" do
      subject(:coversheet) { flow.coversheet }

      it "returns the coversheet node" do
        expect(flow.coversheet).to be_a(Smartdown::Model::Node)
      end

      it "has front matter" do
        expect(coversheet.front_matter).to be_a(Smartdown::Model::FrontMatter)
      end

      describe "front matter" do
        it "has satisfies_need" do
          expect(coversheet.front_matter.satisfies_need).to eq("1234")
        end

        it "has meta_description" do
          expect(coversheet.front_matter.meta_description).to eq("Blah blah")
        end
      end

      it "has a title extracted from the first markdown H1" do
        expect(coversheet.title).to eq("My coversheet")
      end

      it "has a body" do
        expect(coversheet.body).to eq(<<-EXPECTED)

This is the body markdown.

It has many paragraphs
of text.

* it
* can
* have
* lists


And handles multiple new lines

And handles tables

Academic Year | Form
- | -
2015 to 2016 | [PR1 - form (PDF, 569KB)](http://www.sfengland.slc.co.uk/media/860450/sfe_pr1_form_1516_d.pdf)
2015 to 2016 | [PR1 - guidance notes (PDF, 199KB)](http://www.sfengland.slc.co.uk/media/860454/sfe_pr1_notes_1516_d.pdf)
EXPECTED
      end
    end
  end

  context "flow with a cover-sheet and a question" do
    subject(:flow) { Smartdown.parse(fixture("one-question")) }

    it "has two nodes" do
      expect(flow.nodes.size).to eq(2)
      expect(flow.nodes[0]).to eq(flow.coversheet)
      expect(flow.nodes[1]).to be_a(Smartdown::Model::Node)
    end

    describe "the question node" do
      subject(:question_node) { flow.nodes[1] }

      it "has a title" do
        expect(question_node.title).to eq("Question one")
      end

      it "has two body paras" do
        expect(question_node.body).to eq(<<-EXPECTED)

Body text line 1.

Body text
para 2.

EXPECTED
      end

      it "has a post body" do
        expect(question_node.post_body).to eq(<<-EXPECTED)

Text after the question.
EXPECTED
      end

      it "has a multiple choice question" do
        expect(question_node.questions).to match([instance_of(Smartdown::Model::Element::Question::MultipleChoice)])
      end
    end
  end

  context "flow coversheet, question and outcome" do
    subject(:flow) { Smartdown.parse(fixture("question-and-outcome")) }

    it "has three nodes" do
      expect(flow.nodes.size).to eq(3)
    end

    it "has node names" do
      expect(flow.nodes.map(&:name)).to eq(["question-and-outcome", "q1", "o1"])
    end
  end

  context "full flow example" do
    subject(:flow) { Smartdown.parse(fixture("animal-example-simple")) }

    it "parses" do
      expect(flow.instance_of? Smartdown::Model::Flow).to eq(true)
    end
  end

  context "snippets" do
    subject(:flow) { Smartdown.parse(fixture("snippet")) }

    it "has replaced the snippet tag with the snippet contents" do
      expect(flow.nodes.first.elements.any? { |element| element.content.to_s.include? "snippet body" })
    end
  end
end


