OrangeObject = require( "./OrangeObject" ).OrangeObject

class OrangeRunnable extends OrangeObject

    constructor: ( @environment, @in, @out, @err ) ->
        super( )

    start: ( cb ) ->
        if cb
            @addListener "started", cb

        @started( )

    stop: ( cb ) ->
        if cb
            @addListener "stopped", cb

        # This is not correct.. the idea
        # would be to generate multiple outputs
        # from a single input. Hence we shouldn't
        # remove all the listeners.. 
        @in.removeAllListeners

        @stopped( )

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

    error: ( msg ) ->
        @err.write msg
        @stop( )

exports.OrangeRunnable = OrangeRunnable
