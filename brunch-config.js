// See http://brunch.io for documentation.
module.exports = {
  paths: {
    watched: ['app/brunch'],
    public: 'vendor/assets'
  },

  modules: {
    
  },

  files: {
    javascripts: {joinTo: 'javascripts/brunch/app.js'},
    stylesheets: {joinTo: 'stylesheets/brunch/app.css'}
  }
}
