class ChatRoomUser < ApplicationRecord
    # belongs_to 単数形とする。
    belongs_to :user
    belongs_to :chat_room

    has_many :chat_messages
end
