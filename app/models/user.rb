class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # リアクション(自己結合)
  # - LIKEしたユーザ
  has_many :active_relationships, class_name: "Reaction", foreign_key: :to_user_id, dependent: :destroy
  # - LIKEされたユーザ
  has_many :passive_relationships, class_name: "Reaction", foreign_key: :from_user_id, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :self_introduction, length:{ maximum: 500 }

  # enum 男=>0, 女=>1
  enum gender: {man: 0, woman: 1}

  # CarrierWave マウント
  mount_uploader :profile_image, ProfileImageUploader

  # パスワードを入力しなくても情報の更新を許可
  def update_without_current_password(params, *options)

    if params[:password].blank? && params[:password_confirmation].blank?
      # パスワード関連のパラメータを削除
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
