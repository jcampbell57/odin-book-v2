import consumer from "channels/consumer"

consumer.subscriptions.create("PostChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const postDisplay = document.querySelector('#post-display')
    postDisplay.insertAdjacentHTML('afterbegin', data)
  },
});
