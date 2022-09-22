/**
 * Action Cable
 * 
 * クライアント側の処理を担当
 */
import consumer from "./consumer"

const appChatRoom = consumer.subscriptions.create("ChatRoomChannel", {

  // 接続時
  connected() {
    // Called when the subscription is ready for use on the server
  },

  // 切断時
  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // サーバーからのデータ受信時
  received(data) {
    
    const chatMessages = document.getElementById('chat-messages');

    // insertAdjacentHTML + beforeend 要素末尾に項目追加
    chatMessages.insertAdjacentHTML('beforeend', data['chat_message']);
  },
  
  // 購読しているチェネルのspeakメソッドをWebsocket通信経由で呼び出し
  speak: function(chat_message, chat_room_id) {
    return this.perform('speak', { chat_message: chat_message, chat_room_id: chat_room_id });
  }
});

// Enterキーでチャットを送信する
if(/chat_rooms/.test(location.pathname)) {
  $(document).on("keydown", ".chat-room__message-form_textarea", function(e) {
    if (e.key === "Enter") {
      const chat_room_id = $('textarea').data('chat_room_id')

      // speakメソッド実行
      appChatRoom.speak(e.target.value, chat_room_id);
      e.target.value = '';
      e.preventDefault();
    }
  })
}
