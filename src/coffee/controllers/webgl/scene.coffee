settings = require 'app/settings'

module.exports = new THREE.Scene

if settings.fog
	module.exports.fog = new THREE.FogExp2 0x000000, 0.01