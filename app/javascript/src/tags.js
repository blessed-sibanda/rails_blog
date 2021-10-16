const removeTags = () => {
  const tags = document.getElementsByClassName('tags');

  if (tags.length > 0) {
    const removeEls = tags[0].getElementsByClassName('remove-tag');
    for (let removeEl of removeEls) {
      removeEl.addEventListener('ajax:success', () => {
        removeEl.parentElement.remove();
      });
    }
  }
};

window.addEventListener('DOMContentLoaded', () => {
  removeTags();
});

window.addEventListener('turbolinks:load', () => {
  removeTags();
});
