import Vue from 'vue';
import ImageUploader from '../src/vue_components/ImageUploader.vue';

const renderImageUploader = () => {
  const app = new Vue({
    render: (h) => h(ImageUploader),
  }).$mount();

  let uploader = document.querySelector('.vue-image-uploader');
  if (uploader) uploader.replaceWith(app.$el);
};

document.addEventListener('DOMContentLoaded', () => renderImageUploader());

document.addEventListener('turbolinks:load', () => renderImageUploader());
