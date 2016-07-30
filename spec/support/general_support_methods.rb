def sign_into_app(user)
  visit root_path
  click_link "sign-in-button"
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def dispatch_upload
  image_path = File.new(Rails.root + 'spec/support/images/person-placeholder.jpg')

  ActionDispatch::Http::UploadedFile.new(tempfile: image_path, filename: 'person-placeholder.jpg', type: "image/jpg")
end

def params_from_kid_controller(user, dispatch_upload)
  {
    'first_name' => 'jack',
    'last_name' => 'smith',
    'birthdate(1i)' => '2014',
    'birthdate(2i)' => '7',
    'birthdate(3i)' => '30',
    'gender' => 'boy',
    picture: { photo: dispatch_upload },
    'created_by' => user.id
  }
end

def create_profile_picture_for(kid, user)
  Picture.add_picture(user, params_from_kid_controller(user, dispatch_upload), kid.id)
end
