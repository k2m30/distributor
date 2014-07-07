require 'rails_helper'


RSpec.describe 'Full cycle', type: :feature do
  describe 'GET /login_and_visit_alls' do
    User.destroy_all


    it 'cleaned up' do
      expect(User.all.size).to eq(0)
      expect(Group.all.size).to eq(0)
      expect(Item.all.size).to eq(0)
      expect(Site.all.size).to eq(0)
      expect(Row.all.size).to eq(0)
      expect(Log.all.size).to eq(0)
      expect(Settings.all.size).to eq(0)
      expect(Url.all.size).to eq(0)
    end

    it 'goes to root path' do
      visit root_path
      expect(page).to have_content 'Вход'
    end

    user = FactoryGirl.create(:user)

    it 'goes to sign_in path and login successfully' do
      login!(user)
      expect(page).to have_content 'Стоп лист'
    end

    it 'goes to settings page as user' do
      login!(user)
      visit settings_path
      expect(page).to have_content 'Настройки'
      expect(page).not_to have_content 'Импорт настроек сайтов'
    end
    admin = FactoryGirl.create(:admin)

    it 'goes to settings page as admin' do
      login!(admin)
      visit settings_path
      # save_and_open_page
      expect(page).to have_content 'Настройки'
      expect(page).to have_selector('#shops')
      expect(page).to have_selector('#file')
      expect(page).to have_selector('#sites')
    end

    it 'imports all_sites file' do
      login!(admin)
      visit settings_path
      attach_file('sites', 'import/ydachnik/all_sites.xlsx')
      click_link_or_button('all_sites_button')
      expect(page).to have_selector('#preview')
      expect(page).to have_selector('#import')
      click_link_or_button('import')
      expect(page).to have_content 'Магазины'
      expect(page).not_to have_content 'ошибка'
    end

    it 'imports standard file' do
      login!(user)
      visit settings_path
      attach_file('file', 'import/ydachnik/standard.xlsx')
      click_link_or_button('standard_button')
      expect(page).to have_selector('#preview')
      expect(page).to have_selector('#import')
      click_link_or_button('import')
      expect(page).to have_content 'Допустимая погрешность'
      expect(page).not_to have_content 'ошибка'
    end

    it 'imports shops file' do
      login!(user)
      visit settings_path
      attach_file('file', 'import/ydachnik/shops.xlsx')
      click_link_or_button('shops_button')
      save_and_open_page
      expect(page).to have_selector('#preview')
      expect(page).to have_selector('#import')
      click_link_or_button('import')
      expect(page).to have_content 'Допустимая погрешность'
      expect(page).not_to have_content 'ошибка'

    end

    # user.destroy
  end
end