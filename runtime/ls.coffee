OrangeRunnable = require( "../orange" ).OrangeRunnable

fs  = require "fs"

class ls extends OrangeRunnable

    start: ( cb ) ->
        super cb

        # TODO, parse input args to handle 
        # relative and absolute paths..

        fs.readdir @environment.get( "cwd" ), ( err, files ) ->
            if err
                return @error err

            for file in files
                @out.write "\n#{file}"

            @stop( )
