class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_one :image

  # バリデーション
  validates :name, presence: true
  validates :self_introduction, length:{ maximum: 500 }

  enum gender: {man: 0, woman: 1}

  # CarrierWave マウント
  mount_uploader :profile_image, ProfileImageUploader

  # パスワードを入力しなくても情報の更新を許可
  def update_without_current_password(params, *options)

    if params[:password].blank? && params[:password_confirmation].blank?
      # パラメータ削除
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
