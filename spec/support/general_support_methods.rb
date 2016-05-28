def sign_into_app(user)
  visit root_path
  within('ul.navbar-nav') do
    click_link "Sign In"
  end
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end
