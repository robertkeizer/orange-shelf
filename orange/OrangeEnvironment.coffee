OrangeObject  = require( "./OrangeObject" ).OrangeObject

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

exports.OrangeEnvironment = OrangeEnvironment
