require 'smartdown/model/front_matter.rb'

describe Smartdown::Model::FrontMatter do

  subject { described_class.new({ 'key' => :thing }) }

  describe "fetch" do
    context 'Has the attribute desired' do
      it { expect(subject.fetch 'key').to eq(:thing) }

      it "doesn't use the default" do
        expect(subject.fetch 'key', 'default').to eq(:thing)
      end
    end

    context 'Does not have the attribute desired' do
      it 'raises error by default if the attribute is missing' do
        expect { subject.fetch :hahhad }.to raise_error
      end

      it 'allows passing a default to return on failure' do
        expect(subject.fetch :askdjf, 'draft').to eq ('draft')
      end

      it 'allows passing a nil default to return on failure' do
        expect(subject.fetch :askdjf, nil).to be_nil
      end

      it 'raises an error if more than 2 arguments are passed' do
        expect { subject.fetch :askdjf, 'draft', 'x' }.to raise_error(ArgumentError)
      end
    end
  end
end

