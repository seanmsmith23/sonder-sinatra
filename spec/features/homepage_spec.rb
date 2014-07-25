require "spec_helper"
require_relative "../methods/spec_methods"

feature "Homepage" do
  scenario "user that visits homepage sees a register buttion and sign in form" do
    visit '/'

    expect(page).to have_button("Register")
    expect(page).to have_content("Sign In")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Sign In")
  end
end

feature "Register" do
  scenario "user can click the register button and be taken to a register form" do
    visit '/'

    click_button "Register"

    expect(page).to have_content("Register Below")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Register")
  end

  scenario "user can register and be taken back to the homepage" do
    register_a_user("bill")

    expect(page).to have_content("Sonder")
    expect(page).to have_content("A community for")
  end

  scenario "user can login and view the loggedin homepage" do
    register_and_signin_user("bill")

    expect(page).to have_button("Create Memorial")
  end

end

feature "Sign In" do
  scenario "User can click the logout button and be taken back to the logged out homepage" do
    register_and_signin_user("ted")

    click_link "Logout"

    expect(page).to have_button("Register")
    expect(page).to have_content("Sonder")
    expect(page).to have_content("A community for")
  end

end




