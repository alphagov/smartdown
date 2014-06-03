shared_examples "a question" do
  let(:name) { "my_name" }
  let(:body) { "my body" }

  it "has a name" do
    subject.name = name
    expect(subject.name).to eq name
  end

  it "has a body" do
    subject.body = body
    expect(subject.body).to eq body
  end
end
