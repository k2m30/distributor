require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "LoginAndVisitAlls", type: :feature do
  describe "GET /login_and_visit_alls" do
    user = User.find_by(email: 'foo@example.com') || FactoryGirl.create(:user)
    it "goes to root path" do
      visit root_path
      expect(page).to have_content 'Вход'

    end
    it "goes to sign_in path" do
      visit new_user_session_path
      expect(page).to have_content 'Пользователь', 'Пароль'
    end
  end
end
