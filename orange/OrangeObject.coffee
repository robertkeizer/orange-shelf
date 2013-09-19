events  = require "events"

class OrangeObject extends events.EventEmitter
    # This is the basic object for everything
    # on the orange shelf so to speak.

    # Everything has an identifier..
    constructor: ( @_id ) ->

exports.OrangeObject = OrangeObject
