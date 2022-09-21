class ChatRoomsController < ApplicationController
    
    # チャットの作成
    def create

        # ログインユーザーが所属するチャットルームを取得
        current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).pluck(:chat_room_id)

        # クリックユーザーが所属するチャットルームがあるか
        chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).first

        # チャットルームが存在しない場合は作成する
        # トランザクション処理
        begin
            ActiveRecord::Base.transaction do
                if chat_room.blank?
                    chat_room = ChatRoom.create!
                    ChatRoomUser.create!(chat_room_id: chat_room.id, user_id: current_user.id)
                    ChatRoomUser.create!(chat_room_id: chat_room.id, user_id: params[:user_id])
                    raise ActiveRecord::RecordNotSaved
                end
            end
        # エラーログ 書き出し
        rescue => e
            Rails.logger.error e.class
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            # Bugsnag.notify e
        end

        # show への遷移
        redirect_to action: :show, id: chat_room.id
    end
    
    # チャット画面の表示
    def show
    
    end

end
