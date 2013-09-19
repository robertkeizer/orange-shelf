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

exports.OrangeObject        = OrangeObject
exports.OrangeEnvironment   = OrangeEnvironment
exports.OrangeRunnable      = OrangeRunnable
