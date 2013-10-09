OrangeRunnable = require( "../orange" ).OrangeRunnable
fs  = require "fs"

class ls extends OrangeRunnable

    start: ( args, cb ) ->
        super args, ( err ) =>
            if err
                return cb err

            # TODO, parse input args to handle 
            # relative and absolute paths..

            fs.readdir @environment.get( "cwd" ), ( err, files ) =>
                if err
                    @error err
                    return @stop( )

                for file in files
                    @out.write "#{file}\n"

                @stop( )

exports.ls = ls
