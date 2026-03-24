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

    context "user_imageのバリデーション" do
      it "画像なしでも登録できる" do
        user = build(:user)
        expect(user).to be_valid
      end

      it "jpeg画像を添付できる" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("fake"), filename: "test.jpg", content_type: "image/jpeg")
        expect(user).to be_valid
      end

      it "png画像を添付できる" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("fake"), filename: "test.png", content_type: "image/png")
        expect(user).to be_valid
      end

      it "gif画像を添付できる" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("fake"), filename: "test.gif", content_type: "image/gif")
        expect(user).to be_valid
      end

      it "webp画像を添付できる" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("fake"), filename: "test.webp", content_type: "image/webp")
        expect(user).to be_valid
      end

      it "許可されていない形式のファイルは添付できない" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("fake"), filename: "test.pdf", content_type: "application/pdf")
        expect(user).not_to be_valid
        expect(user.errors[:user_image]).to be_present
      end

      it "5MBを超えるファイルは添付できない" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("a" * (5.megabytes + 1)), filename: "large.jpg", content_type: "image/jpeg")
        expect(user).not_to be_valid
        expect(user.errors[:user_image]).to be_present
      end

      it "5MB以下のファイルは添付できる" do
        user = build(:user)
        user.user_image.attach(io: StringIO.new("a" * 4.megabytes), filename: "small.jpg", content_type: "image/jpeg")
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
