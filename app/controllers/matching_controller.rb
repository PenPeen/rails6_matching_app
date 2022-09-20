class MatchingController < ApplicationController
    # ゲストユーザーからのログイン禁止
    before_action :authenticate_user!

    # マッチングページの表示
    # ユーザー表示条件： 相手が自分にいいねをしている。自分も相手にいいねしている。
    def index
        # 自分にいいねしたユーザー
        got_reaction_user_ids = 
            Reaction.where(to_user_id: current_user.id, status: 'like')
            .pluck(:from_user_id)
        
        # 自分がいいねしたユーザーかつ、自分にいいねしたユーザーを取得
        # to_user => to_user_idに対応するUserモデルの取得（モデルでアソシエーションを定義）
        # mapで反復処理を行い、各レコードに対応するユーザー情報を取得
        @match_users = 
        Reaction.where(to_user_id: got_reaction_user_ids, from_user_id: current_user.id, status: 'like')
        .map(&:to_user)
        
        # navbarで使用
        @user = User.find(current_user.id)
    end

end
