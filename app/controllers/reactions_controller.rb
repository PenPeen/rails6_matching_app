class ReactionsController < ApplicationController

    # リアクションの作成
    def create
        # レコード取得（取得できなければインスタンス作成）
        # find_or_create_byは、statusの特定ができない、利用不可
        reaction = Reaction.find_or_initialize_by(to_user_id: params[:user_id], from_user_id: current_user.id)
        
        # レコードの作成状況によって、処理を分岐させる
        # 新規
        if reaction.new_record? 
            reaction.status = params[:reaction]
            reaction.save!
            
        # 既存
        else
            reaction.update(
                status: params[:reaction]
            )
        end
    end
end
