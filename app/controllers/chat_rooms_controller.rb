class ChatRoomsController < ApplicationController
    
    # チャットルームの作成
    def create

        # ログインユーザーが所属するチャットルームを取得
        current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).pluck(:chat_room_id)

        # クリックユーザーが所属するチャットルームを取得（リレーション）
        chat_room = ChatRoomUser.where(chat_room_id: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first

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

            # 監視ツールを使用する場合
            # Bugsnag.notify e
        end

        # リダレクト（リダイレクト先にshowアクションを指定）
        redirect_to action: :show, id: chat_room.id
    end
    
    # チャット画面の表示
    def show
        # ルームID（createアクションから受取）
        room_id = params[:id]

        # メッセージ一覧取得
        # .orderBy(日時順)
        @messages = ChatMessage.where(chat_room_id: room_id).order(:created_at)
        
        @chat_room = ChatRoom.find(params[:id])
        @chat_room_user = @chat_room.chat_room_users.where.not(user_id: current_user.id).first.user
        # @chat_messages = ChatMessage.where(chat_room: @chat_room)
    end
end
