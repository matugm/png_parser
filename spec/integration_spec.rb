
# Need this because of atom multi-project behaviour
Dir.chdir(__dir__)

describe "Integration" do
  it 'produces the expected image' do
    system "ruby ../app.rb"

    a = File.read("../img/output.png")
    b = File.read("../img/expected.png")

    expect(a).to eq b
  end
end
