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
    register_a_user("bill")

    expect(page).to have_content("Homepage")
  end

  scenario "user can login and view the loggedin homepage" do
    register_and_signin_user("bill")

    expect(page).to have_button("Create Memorial")
  end

end

feature "Sign In" do
  scenario "User can click the logout button and be taken back to the logged out homepage" do
    register_and_signin_user("ted")

    click_button "Logout"

    expect(page).to have_button("Register")
    expect(page).to have_content("Homepage")
  end

end

feature "Creating Memorials" do
  scenario "User can click on a button that takes them to a form to create memorial" do
    register_and_signin_user("henry")

    click_button "Create Memorial"

    expect(page).to have_content("New Memorial")
    expect(page).to have_content("Name")
    expect(page).to have_content("Born")
    expect(page).to have_content("Died")
    expect(page).to have_button("Create")
  end

  scenario "User can create a new memorial by filling out the form" do
    register_and_signin_user("frank")
    create_a_memorial

    expect(page).to have_link("Abraham Lincoln")
  end

  scenario "User can add a link to a photo when creating a memorial" do
    register_and_signin_user("todd")

    visit '/create_memorial'

    fill_in "name", :with => "Abraham Lincoln"
    fill_in "born", :with => "02/12/1809"
    fill_in "died", :with => "04/15/1865"
    fill_in "photo", :with => "http://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg/640px-Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg"
    click_button "Create"

    expect(page).to have_link("http://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg/640px-Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg")
  end
end

feature "Using memorials" do
  scenario "User can click a link for their memorial and be taken to the memorial" do
    register_and_signin_user("todd")
    create_a_memorial

    click_link "Abraham Lincoln"

    expect(page).to have_content("Remembering Abraham Lincoln")
    expect(page).to have_content("02/12/1809")
    expect(page).to have_content("04/15/1865")
  end

  scenario "User must be logged in to view memorials" do
    register_and_signin_user("bill")
    create_a_memorial
    logout

    visit "/memorial/1"

    expect(page).to have_content("Homepage")
    expect(page).to have_content("Must be logged in to view memorials")
  end

  scenario "user must join a memorial before they can see it's contents" do
    register_and_signin_user("todd")
    create_a_memorial("Jeff")
    logout
    register_and_signin_user("pete")

    click_link "Jeff"

    expect(page).to have_content("Click below to join the memorial for Jeff")
    expect(page).to have_button("Join")
  end

  scenario "show all memorials for all users" do
    register_and_signin_user("ted")
    create_a_memorial
    logout
    register_and_signin_user("Fred")

    expect(page).to have_link("Abraham Lincoln")
  end

  scenario "joining a memorial should give a user access to it" do
    register_and_signin_user("frank")
    create_a_memorial
    logout
    register_and_signin_user("Bill")

    click_link("Abraham Lincoln")
    click_button("Join")

    expect(page).to have_content("Abraham Lincoln")
    expect(page).to have_content("02/12/1809")
    expect(page).to have_content("04/15/1865")
  end

  scenario "user should see be able to click a button and see a form to add a memory" do
    register_and_signin_user("todd")
    create_a_memorial
    click_link("Abraham Lincoln")

    click_button("New Memory")

    expect(page).to have_content("Add your memory below")
  end

  scenario "add memory form should disappear after the memory is created" do
    register_and_signin_user("ted")
    create_a_memorial
    click_link("Abraham Lincoln")
    click_button("New Memory")

    fill_in "memory", with: "here is some text"
    click_button "Add"

    expect(page).to_not have_content("Add your memory below")
    expect(page).to have_content ("Abe wrote:")
    expect(page).to have_content("here is some text")
  end

  scenario "user can click link and view all members of a memorial" do
    register_and_signin_user("Abe")
    create_a_memorial
    logout
    register_and_signin_user("Ted")

    click_link("Abraham Lincoln")
    click_button("Join")
    click_link("View all members")

    expect(page).to have_content("Abe")
  end
end


