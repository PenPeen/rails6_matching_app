class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  # レコード保存後に実行されるイベント
  # クライアントへData送信（WebSocket）
  def perform(chat_message)
    ActionCable.server.broadcast 'chat_room_channel',{chat_message: render_chat_message(chat_message)}
  end
  
  # レンダリング
  private
    def render_chat_message(chat_message)
      ApplicationController.renderer.render(partial: 'chat_messages/chat_message', locals: { chat_message: chat_message, current_user: chat_message.user} )
    end
end
