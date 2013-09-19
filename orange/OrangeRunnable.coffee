OrangeObject = require( "./OrangeObject" ).OrangeObject

class OrangeRunnable extends OrangeObject
    is_running: ( cb ) ->
        if not @_running?
            return false
        @_running

    started: ( ) ->
        @_running       = true
        @_time_started  = new Date( )
        @emit "started"

    stopped: ( ) ->
        @_running = false
        @emit "stopped"

exports.OrangeRunnable = OrangeRunnable
