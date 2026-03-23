require "rails_helper"

RSpec.describe User, type: :model do
  describe "新規登録" do
    context "有効な属性の場合" do
      it "name, email, password, password_confirmationがあれば登録できる" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "nameのバリデーション" do
      it "nameが空の場合は登録できない" do
        user = build(:user, name: "")
        expect(user).not_to be_valid
        expect(user.errors[:name]).to be_present
      end

      it "nameが255文字以内であれば登録できる" do
        user = build(:user, name: "a" * 255)
        expect(user).to be_valid
      end

      it "nameが256文字以上の場合は登録できない" do
        user = build(:user, name: "a" * 256)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to be_present
      end
    end

    context "emailのバリデーション" do
      it "emailが空の場合は登録できない" do
        user = build(:user, email: "")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end

      it "同じemailが既に登録されている場合は登録できない" do
        create(:user, email: "test@example.com")
        user = build(:user, email: "test@example.com")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end

      it "異なるemailであれば登録できる" do
        create(:user, email: "first@example.com")
        user = build(:user, email: "second@example.com")
        expect(user).to be_valid
      end
    end

    context "passwordのバリデーション" do
      it "passwordが空の場合は登録できない" do
        user = build(:user, password: "", password_confirmation: "")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end

      it "passwordが7文字以下の場合は登録できない" do
        user = build(:user, password: "pass123", password_confirmation: "pass123")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end

      it "passwordが8文字以上であれば登録できる" do
        user = build(:user, password: "password8", password_confirmation: "password8")
        expect(user).to be_valid
      end

      it "password_confirmationがpasswordと一致しない場合は登録できない" do
        user = build(:user, password: "password8", password_confirmation: "different")
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to be_present
      end
    end
  end
end
