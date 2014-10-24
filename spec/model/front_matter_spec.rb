require 'smartdown/model/front_matter.rb'

describe Smartdown::Model::FrontMatter do

  subject { described_class.new({ 'key' => :thing }) }

  describe "fetch" do
    context 'Has the attribute desired' do
      it { expect(subject.fetch 'key').to eq(:thing) }
    end

    context 'Does not have the attribute desired' do
      it 'raises error by default if the attribute is missing' do
        expect { subject.fetch :hahhad }.to raise_error
      end

      it 'allows passing a default to return on failure' do
        expect(subject.fetch :askdjf, nil).to be_nil
      end
    end
  end
end

