OrangeRunnable = require( "../orange" ).OrangeRunnable

class cd extends OrangeRunnable
    
    start: ( args, cb ) ->

        super args, ( err ) =>
            if err
                return cb err
            
            # Change the @environment.cwd based on args.
            

exports.cd = cd
