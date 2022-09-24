class ChatMessage < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room

    # フック: 処理データ保存後に「ChatMessageBroadcastJob」を実行
    after_create_commit { ChatMessageBroadcastJob.perform_later self }
end
