def register_a_user(email=nil)
  visit '/register'

  if email
    fill_in "email", :with => "#{email}"
  else fill_in "email", :with => "abelincoln@gmail.com"
  end

  fill_in "password", :with => "secretcode"

  click_button "Register"
end

def sign_user_in(email=nil)
  visit '/'

  if email
    fill_in "email", :with => "#{email}"
  else fill_in "email", :with => "abelincoln@gmail.com"
  end

  fill_in "password", :with => "secretcode"

  click_button "Sign In"
end