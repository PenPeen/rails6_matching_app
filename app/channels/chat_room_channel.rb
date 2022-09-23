# Action Cable
# サーバーサイド側の処理を担当 

class ChatRoomChannel < ApplicationCable::Channel

  # consumerがchannelに接続した時の処理
  def subscribed
    # chat_room_channelを使用
    stream_from "chat_room_channel"
  end

  # consumerがchannelから接続解除した時の処理
  def unsubscribed

  end

  # chat_room_channel.jsから呼び出し
  # receivedメソッドへのデータ送信（broadcast)
  def speak(data)
    ChatMessage.create!(
      content: data['chat_message'],
      user_id: current_user.id,
      chat_room_id: data['chat_room_id']
    )
  end
end
