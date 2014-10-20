shared_examples "flow input interface" do
  it { should respond_to(:coversheet) }
  it { should respond_to(:questions) }
  it { should respond_to(:outcomes) }
  it { should respond_to(:scenario_sets) }
  it { should respond_to(:snippets) }
end
