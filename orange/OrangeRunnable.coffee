OrangeObject = require( "./OrangeObject" ).OrangeObject

class OrangeRunnable extends OrangeObject

    constructor: ( @environment, @in, @out, @err ) ->
        super( )

    start: ( args, cb ) ->

        # Cannot start if already running.
        if @is_running( )
            return cb "Already running"
            
        # If a cb has been specified. Add it to the started event.
        if cb
            @once "started", cb

        # Set the arguments that have been specified to be
        # instance wide.
        @_args  = args
        
        # We're now going to be 'started', so set the flag.
        # Also set the time started and emit the started event.
        @_running = true
        @_time_started  = new Date( )
        @emit "started"

    stop: ( cb ) ->
        if cb
            @once "stopped", cb

        @_running = false
        @emit "stopped"
        
    is_running: ( ) ->
        if not @_running?
            return false
        @_running

    error: ( msg ) ->
        @err.write msg

exports.OrangeRunnable = OrangeRunnable
