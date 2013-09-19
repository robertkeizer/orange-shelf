events  = require "events"

class OrangeObject extends events.EventEmitter
    constructor: ( @_id ) ->
 
class Environment extends OrangeObject
    constructor: ( @_id ) ->
        
    get: ( what, cb ) ->
        if cb
            return cb @[what]
        return @[what]

    set: ( what_name, what_obj, cb ) ->
        @[what_name] = what_obj
        if cb
            @updated( )
            return cb( )
        @updated( )

    updated: ( what ) ->
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

# Just some example stuff.
setTimeout ( ) ->
    if yas.is_running( )
        log "Yas was started #{yas._time_started}"
, 5000
