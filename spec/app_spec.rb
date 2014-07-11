require "spec_helper"
require_relative "spec_methods"

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

    click_link "Register"

    expect(page).to have_content("Register Below")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Register")
  end

  scenario "user can register and be taken back to the homepage" do
    register_a_user

    expect(page).to have_content("Homepage")
  end

  scenario "user can login and view the loggedin homepage" do
    register_a_user("abe")
    sign_user_in("abe")

    expect(page).to have_button("Create Memorial")
  end
end