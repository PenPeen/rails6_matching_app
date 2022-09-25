# UsersControllre
# 
# ユーザーに関する処理
class  UsersController < ApplicationController
    # ログインしているユーザーのみアクセスを許可
    before_action :authenticate_user!

    # スワイプ画面を表示する
    # 
    # @params[nil]
    # @return[nil]
    def index
        # 自分以外のユーザーを取得
        @users = User.where.not(id: current_user.id)
        @user = User.find(current_user.id)
    end

    # ユーザーのプロフィールを表示する
    # 
    # @params [nil]
    # @return[nil]
    def show
        @user = User.find(params[:id])
    end
end
