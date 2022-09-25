class ReactionsController < ApplicationController
    # ゲストユーザーからのログイン禁止
    before_action :authenticate_user!

    # リアクション結果を保存する
    # @params [nil]
    # @return [nil]
    def create
        # レコード取得（取得できなければインスタンス作成）
        # find_or_create_byは、statusの特定ができない、利用不可
        reaction = Reaction.find_or_initialize_by(to_user_id: params[:user_id], from_user_id: current_user.id)
        
        # レコードの作成状況によって、処理を分岐させる
        # 新規レコードの場合
        if reaction.new_record? 
            reaction.status = params[:reaction]
            reaction.save!
            
        # 既存レコードの場合
        else
            reaction.update!(
                status: params[:reaction]
            )
        end
    end
end
