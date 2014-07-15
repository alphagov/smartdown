describe "bin/smartdown" do
  subject(:the_executable) { "bin/smartdown" }

  it "is executable" do
    expect(File.executable?(the_executable)).to eq(true)
  end

  describe "invocation with no arguments" do
    subject(:output) { `#{the_executable} 2>&1` }

    it "reports usage" do
      expect(output).to match(/usage/i)
      expect($?.exitstatus).to eq(1)
    end
  end
end
