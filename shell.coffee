events  = require "events"

class OrangeObject extends events.EventEmitter
    # This is the basic object for everything
    # on the orange shelf so to speak.

    # Everything has an identifier..
    constructor: ( @_id ) ->
 
class OrangeEnvironment extends OrangeObject

    # The orange environment is in effect a collection
    # of key value pairs. Any updates to the environment
    # fire off an event.

    get: ( what, cb ) ->
        # Simply return the value of @[what]. If it
        # is undefined, that will be returned. Also
        # note that the callback is optional.
        if cb
            return cb @[what]
        return @[what]

    set: ( key, val, cb ) ->

        # Set the particular key to a val.
        # There is no checking done to see if
        # key already exists.

        # This function calls @updated to signal
        # that an update has taken place.

        # cb is optional.

        @[key] = val
        if cb
            @updated( )
            return cb( )
        @updated( )

    updated: ( what ) ->
        # Simply fire off an event that
        # something has changed.

        @emit "updated", what

class Runnable extends OrangeObject
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
    
class Shell extends Runnable
    constructor: ( @_id, @environment, @out, @in ) ->

        # Optionally hook into any environment changes we care
        # about.
        @environment.on "updated", ( what ) ->
            log "Shell noticed that #{what} changed."

    start: ( cb ) ->
        if cb
            @addListener "started", cb

        @started( )

        @runtime_loop( )

    stop: ( cb ) ->
        if cb
            @addListener "stopped", cb

        @in.removeAllListeners

        @stopped( )

    prompt: ( ) ->
        _cwd = @environment.get "cwd"
        
        @out.write "#{@_id}:#{_cwd}>"

    parse_and_run: ( input ) ->
        @out.write "\nWould parse '#{input}' as a command.\n"

    runtime_loop: ( ) ->
        @out.write "\n"
        @prompt( )

        @in.on "data", ( chunk ) =>
            input = chunk.toString( ).replace RegExp( "\n$"), ""
            if input is ""
                return @prompt()

            @parse_and_run input
            @prompt( )

        @in.on "end", ( ) =>
            @stop( )

# Define a log mechanism. Also resume stdin read.
log = require( "logging" ).from __filename
process.stdin.resume( )

# Create a simple environment
env = new Environment "ARandomIdentifier"
env.set "cwd", "/tmp"

# Start a shell in that environment, using stdin and stdout.
yas = new Shell "SomeIdentifier", env, process.stdout, process.stdin
yas.start ( ) ->
    log "Started yas shell!"

yas.on "stopped", ( ) ->
    log "YAS has stopped!"
