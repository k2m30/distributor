require 'rails_helper'


RSpec.describe 'LoginAndVisitAlls', type: :feature do
  describe 'GET /login_and_visit_alls' do
    p 'New user'
    User.destroy_all
    user = FactoryGirl.create(:user)

    it 'goes to sign_in path and login successfully' do
      login!(user)
      expect(page).to have_content 'Стоп лист'
    end

    it 'goes to settings page as user' do
      # login!(user)
      # visit settings_path
      # expect(page).to have_content 'Настройки'
      # expect(page).not_to have_content 'Импорт настроек сайтов'
    end
    user.update(admin: true)

    it 'goes to settings page as admin' do
      # login!(user)
      # visit settings_path
      # expect(page).to have_content 'Настройки'
      # expect(page).to have_content 'Импорт настроек сайтов'
    end

    it 'imports all_sites file' do

    end

    user.update(admin: false)

    it 'imports standard file' do

    end

    it 'imports shops file' do

    end


    it 'goes to root path' do
      visit root_path
      expect(page).to have_content 'Вход'

    end
    # user.destroy
  end
end