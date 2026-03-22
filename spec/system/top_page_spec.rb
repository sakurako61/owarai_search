require 'rails_helper'

RSpec.describe 'TOPページ', type: :system do
  before do
    driven_by :rack_test
    visit root_path
  end

  describe 'ヘッダー' do
    it 'アプリ名が表示されている' do
      expect(page).to have_content('お笑いライブ検索アプリ')
    end

    it 'ログインリンクが表示されている' do
      expect(page).to have_content('ログイン')
    end

    it '新規登録リンクが表示されている' do
      expect(page).to have_content('新規登録')
    end
  end

  describe 'フッター' do
    it '利用規約が表示されている' do
      expect(page).to have_content('利用規約')
    end

    it 'プライバシーポリシーが表示されている' do
      expect(page).to have_content('プライバシーポリシー')
    end

    it 'お問い合わせが表示されている' do
      expect(page).to have_content('お問い合わせ')
    end
  end

  describe 'サイドバー' do
    it 'ライブ一覧リンクが表示されている' do
      expect(page).to have_content('ライブ一覧')
    end
  end
end
