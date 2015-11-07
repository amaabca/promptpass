describe "Testing welcome page" do
  it "checks the welcome page" do
    visit root_path

    expect(page).to have_content 'hi2u'
  end
end