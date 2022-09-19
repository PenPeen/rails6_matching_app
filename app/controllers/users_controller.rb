class  UsersController < ApplicationController
    # ログインしているユーザーのみアクセスを許可
    before_action :authenticate_user!

    def index
        # 自分以外のユーザーを取得
        @users = User.where.not(id: current_user.id)
        @user = User.find(current_user.id)
    end

    def show
        @user = User.find(params[:id])
    end
end
