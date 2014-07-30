def register_a_user(email)
  visit '/register'

  fill_in "first", with: "Abe"
  fill_in "last", with: "Lincoln"
  fill_in "email", :with => "#{email}"
  fill_in "password", :with => "secretcode"

  click_button "Register"
end

def sign_user_in(email=nil)
  visit '/'

  fill_in "email", :with => "#{email}"
  fill_in "password", :with => "secretcode"

  click_button "Sign In"
end

def register_and_signin_user(email=nil)
  register_a_user(email)
  sign_user_in(email)
end

def create_a_memorial(name=nil)
  visit '/create_memorial'

  if name
    fill_in "name", :with => "#{name}"
  else fill_in "name", :with => "Abraham Lincoln"
  end

  fill_in "born", :with => "02/12/1809"
  fill_in "died", :with => "04/15/1865"
  fill_in "photo", :with => "http://www.sample.jpg"

  click_button "Create"
end

def logout
  visit "/logout"
end

def find_and_join(name)
  click_button("Find Memorial")
  click_link(name)
  click_button("Join")
end
