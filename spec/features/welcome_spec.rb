describe "Testing welcome page" do
  it "checks the welcome page" do
    visit root_path

    expect(page).to have_content 'Hello World'
  end
end