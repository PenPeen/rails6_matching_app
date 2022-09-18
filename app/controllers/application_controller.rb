class ApplicationController < ActionController::Base
  # devise情報登録
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Devise ストロングパラメータを追加
  # https://github.com/heartcombo/devise#strong-parameters
  protected
    def configure_permitted_parameters
        # 登録時
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender])
        # 更新時
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :self_introduction])
    end
end
