require 'smartdown/parser/element/front_matter'

describe Smartdown::Parser::Element::FrontMatter do

  subject { described_class.new }

  it { should parse("a: 1\n").as(front_matter: [{name: "a", value: "1"}]) }
  it { should parse("a: 1\nb: 2\n").as(front_matter: [{name: "a", value: "1"}, {name: "b", value: "2"}]) }
end

