require "spec_helper"

feature "Homepage" do
  scenario "user that visits homepage sees a register buttion" do
    visit '/'

    expect(page).to have_content("Register")
  end
end