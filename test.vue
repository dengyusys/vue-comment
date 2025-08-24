<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>Welcome to Vue.js comment plugin test</p>
    <button @click="handleClick">Click me</button>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      msg: 'Hello Vue!'
    }
  },
  methods: {
    handleClick() {
      console.log('Button clicked')
      alert('Hello from Vue component!')
    }
  }
}
</script>

<style scoped>
.hello {
  text-align: center;
  padding: 20px;
}

h1 {
  color: #42b883;
  font-size: 2em;
  margin-bottom: 20px;
}

button {
  background-color: #42b883;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
}
</style>
