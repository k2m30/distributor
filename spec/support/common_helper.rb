def login!(user)
  visit new_user_session_path
  fill_in 'user_username', with: user.username
  fill_in 'user_password', with: user.username
  click_link_or_button('form_submit')
end