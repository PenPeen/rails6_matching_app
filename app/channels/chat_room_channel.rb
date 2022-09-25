# Action Cable
# サーバーサイド側の処理を担当 
class ChatRoomChannel < ApplicationCable::Channel

  # ConsumerがChannelに接続した時(subscribe)
  def subscribed
    # チャネルの設定
    stream_from "chat_room_channel"
  end

  # consumerがchannelから接続解除した時の処理
  def unsubscribed
  end

  # receivedメソッドへのデータ送信（broadcast)
  # chat_room_channel.jsから呼びされる
  # current_user.idメソッドがチャネル内では呼び出しできないため、app/channels/application_cable/connection.rbで独自プロパティ定義
  def speak(data)
    ChatMessage.create!(
      content: data['chat_message'],
      user_id: current_user.id,
      chat_room_id: data['chat_room_id']
    )
  
    # レコード保存後、「ChatMeesageBroadcastJob」が実行
  end
end
