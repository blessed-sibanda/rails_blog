<template>
  <div class="field">
    <div class="image">
      <div class="d-flex" v-if="imageUrl">
        <img :src="imageUrl" alt="" />
        <button @click="remove" title="Remove" class="btn-close"></button>
      </div>
      <img v-else :src="currentAvatarUrl" alt="" />
    </div>

    <label class="form-label" for="user[avatar]">Avatar</label>
    <input
      @change="loadImage"
      type="file"
      name="user[avatar]"
      class="form-control avatar-control"
      accept="image/*"
    />
  </div>
</template>

<script>
export default {
  data() {
    return {
      imageUrl: null,
      currentAvatarUrl: null,
    };
  },
  methods: {
    loadImage(e) {
      let image = e.target.files[0];
      this.imageUrl = URL.createObjectURL(image);
    },
    remove() {
      this.imageUrl = null;
    },
  },
  mounted() {
    let currentAvatar = document.querySelector('.current-avatar');
    if (currentAvatar) {
      this.currentAvatarUrl = currentAvatar.getAttribute('src');
      currentAvatar.remove();
    }
  },
};
</script>

<style>
img {
  object-fit: cover;
  max-height: 170px;
  border: 1px solid #ddd;
  display: block;
}

.image img {
  margin-bottom: 0.5em;
}
</style>
