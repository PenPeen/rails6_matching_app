# ApplicationController
class ApplicationController < ActionController::Base

  # devise_controllre before_action
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    # Devise ストロングパラメータを追加
    # 
    # @params [nil]
    # https://github.com/heartcombo/devise#strong-parameters
    def configure_permitted_parameters
        # 登録時
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender])
        # 更新時
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :self_introduction,:profile_image])
    end
  end
