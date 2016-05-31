def sign_into_app(user)
  visit root_path
  click_link "sign-in-button"
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end
