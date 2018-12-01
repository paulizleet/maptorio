// See http://brunch.io for documentation.
module.exports = {
  paths: {
    watched: ['app/brunch'],
    public: 'vendor/assets'
  },

  modules: {
    wrapper: false
  },

  files: {
    javascripts: {joinTo: 'assets/javascripts/brunch/app.js'},
    stylesheets: {joinTo: 'assets/stylesheets/brunch/app.css'}
  }
}
