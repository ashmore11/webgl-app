settings      = require 'app/settings'
cameras       = require 'app/controllers/webgl/cameras'
scene 		  = require 'app/controllers/webgl/scene'
renderer      = require 'app/controllers/webgl/renderer'
controls      = require 'app/controllers/webgl/controls'
gui 		  = require 'controllers/gui'
win 	      = require 'utils/window'
RAF 	      = require 'utils/raf'
happens       = require 'happens'
View 		  = require 'views/index'

module.exports = new class Index

	game: null

	constructor: ->

		happens @

		@el = $ '#app'

		###
		Camera
		###

		zoom = ( camera, zoom ) ->

			camera.position.set 1 * zoom, 0.75 * zoom, 1 * zoom
			camera.lookAt new THREE.Vector3

		zoom cameras.dev, 60
		zoom cameras.user, 60
				
		###
		Renderer
		###

		renderer.setSize win.width, win.height
		renderer.shadowMapEnabled = on

		@el.append renderer.domElement

		if settings.debug

			###
			Helpers
			###

			scene.add new THREE.GridHelper 50, 10
			scene.add new THREE.AxisHelper 10


		###
		Scene
		###

		if settings.fog
			gui.add( scene.fog, 'density', 0, 0.1)


		###
		View
		###

		@view = new View

		###
		Bind
		###
	
		do @_bind

	###
	Private API
	###

	_bind: ->

		win.on 'resize', @_resize
		RAF.on 'tick', @_update

	_update: =>

		do controls.update

		if settings.debug
			@_render cameras.dev,  0, 0, 1, 1
			# @_render cameras.user, 0, 0, 0.25, 0.25

		else
			@_render cameras.user, 0, 0, 1, 1
			# @_render cameras.dev,  0, 0, 0.25, 0.25
			
	_render: ( camera, left, bottom, width, height ) ->

		left   *= win.width
		bottom *= win.height
		width  *= win.width
		height *= win.height

		cameras.dev.updateProjectionMatrix()
		cameras.user.updateProjectionMatrix()

		renderer.setViewport       left, bottom, width, height
		renderer.setScissor        left, bottom, width, height
		renderer.enableScissorTest true
		renderer.setClearColor     0x121212

		renderer.render( scene, camera )

	_resize: =>

		cameras.dev.aspect  = win.width / win.height
		cameras.user.aspect = win.width / win.height
		
		cameras.dev.updateProjectionMatrix()
		cameras.user.updateProjectionMatrix()

		renderer.setSize win.width, win.height