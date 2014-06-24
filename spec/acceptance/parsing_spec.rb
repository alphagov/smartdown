require 'smartdown.rb'

describe Smartdown do

  def fixture(name)
    File.dirname(__FILE__) + "/../fixtures/acceptance/#{name}/#{name}.txt"
  end

  context "flow with only a cover-sheet" do
    subject(:flow) { Smartdown.parse(fixture("cover-sheet")) }

    describe "#parse" do
      it "should build a Flow model" do
        expect(flow).to be_a(Smartdown::Model::Flow)
      end

      it "should derive the name from the filename" do
        expect(flow.name).to eq("cover-sheet")
      end

      it "should have a coversheet" do
        expect(flow.coversheet).to be_a(Smartdown::Model::Coversheet)
      end

      it "should have no questions" do
        expect(flow.questions).to eq([])
      end

      describe "coversheet" do
        subject(:coversheet) { flow.coversheet }

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
      end
    end
  end
end

