require "spec_helper"
require_relative "../methods/spec_methods"

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

    expect(find("img")['src']).to eq("http://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg/640px-Lincoln_O-14_by_Roderick_Cole%2C_1858.jpg")
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

    expect(page).to have_content("Sonder")
    expect(page).to have_content("Must be logged in to view memorials")
  end

  scenario "user must join a memorial before they can see it's contents" do
    register_and_signin_user("todd")
    create_a_memorial("Jeff")
    logout
    register_and_signin_user("pete")

    click_button "Find Memorial"
    click_link "Jeff"

    expect(page).to have_content("Click below to join this memorial")
    expect(page).to have_button("Join")
  end

  scenario "user can click find memorial buttong and search for a memorial" do
    register_and_signin_user("ted")
    create_a_memorial
    logout
    register_and_signin_user("Fred")
    click_button "Find Memorial"

    expect(page).to have_link("Abraham Lincoln")
  end

  scenario "joining a memorial should give a user access to it" do
    register_and_signin_user("frank")
    create_a_memorial
    logout
    register_and_signin_user("Bill")

    click_button("Find Memorial")
    click_link("Abraham Lincoln")
    click_button("Join")

    expect(page).to have_content("Abraham Lincoln")
    expect(page).to have_content("02/12/1809")
    expect(page).to have_content("04/15/1865")
  end

  scenario "user should see a form to add a memory" do
    register_and_signin_user("todd")
    create_a_memorial
    click_link("Abraham Lincoln")

    expect(page).to have_button("Add")
  end

  scenario "user can click link and view all members of a memorial" do
    register_and_signin_user("Abe")
    create_a_memorial
    logout
    register_and_signin_user("Ted")
    click_button("Find Memorial")
    click_link("Abraham Lincoln")
    click_button("Join")

    click_link("View all members")

    expect(page).to have_content("Abe")
  end

  scenario "user should be able to add memories and see them on the memorial page" do
    register_and_signin_user("tom")
    create_a_memorial
    click_link("Abraham Lincoln")

    fill_in "memory", with: "He was super honest"
    click_button "Add"

    expect(page).to have_content("He was super honest")
  end

  scenario "user should be able to favorite a memory on the memorial page" do
    register_and_signin_user("tom")
    create_a_memorial
    click_link("Abraham Lincoln")
    fill_in "memory", with: "He was super honest"
    click_button "Add"
    logout

    register_and_signin_user("frank")
    click_button("Find Memorial")
    click_link("Abraham Lincoln")
    click_button("Join")

    expect(page).to have_content("He was super honest")

    page.find('.favorite_button').click

    expect(page).to have_content("1")
  end
end


