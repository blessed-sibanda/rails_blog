import consumer from './consumer';

consumer.subscriptions.create('CommentsChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel

    const commentsElement = document.querySelector(
      `#${data.commentable}_${data.id}_comments`,
    );

    if (commentsElement) {
      let modal = commentsElement.querySelector('.modal');
      let backdrop = document.querySelector('.modal-backdrop');

      if (modal) {
        modal.classList.toggle('show');
      }

      if (backdrop) {
        backdrop.remove();
      }

      document.body.classList.toggle('modal-open');
      document.body.removeAttribute('data-bs-padding-right');
      document.body.removeAttribute('style');
    }

    commentsElement.innerHTML = data.html;
  },
});
