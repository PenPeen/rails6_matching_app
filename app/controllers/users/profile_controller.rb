class Users::ProfileController < ApplicationController
    # ログインしているユーザーのみアクセスを許可
    before_action :authenticate_user!

    def show
        @user = User.find(params[:id])
    end
end
