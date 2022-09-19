class Users::RegistrationsOverrideController < Devise::RegistrationsController
    
    # アップデート処理のオーバーライド
    # パスワードの入力を不要にする。
    # ただし、この設定にすると、ユーザーはパスワードの変更を実施できなくなるため、注意が必要（別のアクションを用意）
    protected

    # Userモデル.update_without_password実行（パスワードパラメータ削除）
    def update_resource(resource, params)
        resource.update_without_password(params)
    end

    def after_update_path_for(resource)
        user_path(resource)
    end

    # サインアップ後のリダレクト先変更
    def after_sign_up_path_for(resource)
    users_path
    end
end
