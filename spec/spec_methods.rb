def register_a_user(email)
  visit '/register'

  fill_in "email", :with => "#{email}"
  fill_in "password", :with => "secretcode"

  click_button "Register"
end