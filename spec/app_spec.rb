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

    click_button "Register"

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
    register_and_signin_user

    expect(page).to have_button("Create Memorial")
  end
end

feature "Signed In" do
  scenario "User can click the logout button and be taken back to the logged out homepage" do
    register_and_signin_user

    click_button "Logout"

    expect(page).to have_button("Register")
    expect(page).to have_content("Homepage")
  end
end

feature "Memorials" do
  scenario "User can click on a button that takes them to a form to create memorial" do
    register_and_signin_user

    click_button "Create Memorial"

    expect(page).to have_content("New Memorial")
    expect(page).to have_content("Name")
    expect(page).to have_content("Born")
    expect(page).to have_content("Died")
    expect(page).to have_button("Create")
  end

  scenario "User can create a new memorial by filling out the form" do
    register_and_signin_user
    create_a_memorial

    expect(page).to have_link("Abraham Lincoln")
  end
end
