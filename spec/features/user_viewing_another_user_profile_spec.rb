# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'

# Начинаем описывать функционал, связанный с созданием игры
RSpec.feature 'USER viewing another user profile', type: :feature do
  let(:user) { FactoryGirl.create :user, name: 'Юзер' }
  let(:another_user) { FactoryGirl.create :user, name: 'Второй юзер' }

  let!(:games) do
    [
      FactoryGirl.create(:game, user: another_user, id: 1, created_at: Time.parse('11.02.2021 14:40'), finished_at: Time.parse('12.02.2021 14:40'), current_level: 4,  prize: 500),
      FactoryGirl.create(:game, user: another_user, id: 2, created_at: Time.parse('01.03.2021 14:40'), current_level: 6)
    ]
  end

  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    # Заходим на главную
    visit '/'
    click_link 'Второй юзер'

    # Ожидаем, что на экране вопрос игры (самый простой)
    expect(page).to have_content 'Второй юзер'
    expect(page).not_to have_content 'Сменить имя и пароль'

    # Ожидаем, что будет на экране по первой игре
    expect(page).to have_content '1'
    expect(page).to have_content 'деньги'
    expect(page).to have_content '11 февр., 14:40'
    expect(page).to have_content '4'
    expect(page).to have_content '500 ₽'

    # Ожидаем, что будет на экране по второй игре
    expect(page).to have_content '2'
    expect(page).to have_content 'в процессе'
    expect(page).to have_content '01 марта, 14:40'
    expect(page).to have_content '6'
    expect(page).to have_content '0 ₽'
  end
end
