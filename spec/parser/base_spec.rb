require 'smartdown/parser/element/front_matter'

describe Smartdown::Parser::Base do

  subject(:parser) { described_class.new }

  describe "#ws" do
    subject { parser.ws }
    it { should parse("\n") }
    it { should parse(" ") }
    it { should parse("   ") }
  end

  describe "#eof" do
    subject { parser.eof }

    it { should parse("") }
    it { should_not parse(" ") }
  end

  describe "#newline" do
    subject { parser.newline }

    # Only one newline
    it { should parse("\r") }
    it { should parse("\r\n") }
    it { should parse("\n\r") }
    it { should parse("\n") }

    # Not multiple
    it { should_not parse("\n\n") }
  end

  describe "#whitespace_terminated_string" do
    subject { parser.whitespace_terminated_string }

    it { should parse("a b c") }
    it { should_not parse(" a") }
    it { should_not parse("a ") }
  end

  describe "identifier" do
    subject { parser.identifier }

    it { should parse("abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZ-123") }
    it { should_not parse("abc_ABC-123?") }
  end
end

