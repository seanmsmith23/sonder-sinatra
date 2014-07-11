require "spec_helper"

feature "Homepage" do
  scenario "user that visits homepage sees a register buttion" do
    visit '/'

    expect(page).to have_content("Register")
  end
end

feature "Register" do
  scenario "user can click the register button and be taken to a register form" do
    visit '/'

    click_link "Register"

    expect(page).to have_content("Register Below")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_content("Register")
  end
end