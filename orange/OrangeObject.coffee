events      = require "events"
OrangeIdent = require( "./OrangeIdent" ).OrangeIdent

class OrangeObject extends events.EventEmitter
    # This is the basic object for everything
    # on the orange shelf so to speak.

    # Everything has an identifier..
    constructor: ( @_id ) ->
        if not @_id
            @_id = OrangeIdent( )

exports.OrangeObject = OrangeObject
