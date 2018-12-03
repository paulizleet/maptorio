// See http://brunch.io for documentation.
module.exports = {
  paths: {
    watched: ['app/brunch'],
    public: 'vendor/assets'
  },

  modules: {
    wrapper: false //IT WAS THIS ALL ALONG AAAAAAAAAAAAAAAAAAAA
  },

  /*npm: {
    globals:{
      cy: "cytoscape",
      coseBilkent: 'cytoscape-cose-bilkent'
    }
  },*/

  files: {
    javascripts: {joinTo: {'javascripts/brunch/app.js': /^app/,
                           'javascripts/brunch/vendor.js': /^node_modules/}},
    stylesheets: {joinTo: 'stylesheets/brunch/app.css'}
  }
}
