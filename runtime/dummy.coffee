log     = require( "logging" ).from __filename
orange  = require "../orange"

class dummy extends orange.OrangeRunnable
    start: ( args ) ->
        super args, ( err ) =>
            if err
                return cb err

            log "Successfully started."

            log "Running.."
            setTimeout ( ) =>
                log "Exiting.."
                @stop( )
            , 1000
        
exports.dummy = dummy
