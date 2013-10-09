log     = require( "logging" ).from __filename
coffee  = require "coffee-script"
orange  = require "../orange"

fs      = require "fs"
path    = require "path"

class shell extends orange.OrangeRunnable

    start: ( args ) ->
        super args, ( err ) =>
            if err
                return cb err

            log "Started shell."

            # Initial prompt, nothing more.
            @prompt( )

            # Define the function that will handle the chunks coming in off of input.
            handle_input_chunks = ( chunk ) =>
                # Parse the input.. not the most elegant piece of code, but it works.
                input = chunk.toString().replace RegExp( "\n$" ), ""

                # Handle black lines gracefully.
                if input is ""
                    return @prompt( )
                
                # Parse and run the command. When it is finished, prompt again.
                @parse_and_run input, ( ) =>
                    @prompt( )

            # Create the listener on input data.
            @in.on "data", handle_input_chunks

            # When we get stopped, remove the input listener.
            @once "stopped", ( ) =>
                @in.removeListener "data", handle_input_chunks
                log "Removed the input listeners for shell."

    prompt: ( ) ->
        _cwd = @environment.get "cwd"
        @out.write "#{@_id}:#{_cwd}>"

    parse_and_run: ( input, cb ) ->

        # Builtins..
        if input is "quit"
            #log "Stopping.."
            return @stop( )


        # Find the path of the given coffee file..
        # or keep the _valid_path set to false.
        _valid_path = false
        for _path in @environment.get( "path" )
            _possible_path = path.join _path, "#{input}.coffee"
            if fs.existsSync _possible_path
                _valid_path = _possible_path
                break

        # Exit out if we couldn't find the command.
        if not _valid_path
            @error "Unknown command.\n"
            return cb( )

        # Figure the path that we're going to require.
        _require_path = "./" + path.join( path.dirname( _valid_path ), path.basename( _valid_path, ".coffee" ) )
    
        # Get the module.. this is ugly right now and uses a coffeescript eval.. urgh. 
        _m = coffee.eval "require '#{_require_path}'"

        # Create a new instance of the given object, passing in the particulars.
        _o = new _m[input] @environment, @in, @out, @err

        # When the Runnable is done running, it will emit a "stopped".
        # Listen for that and cb when it happens.
        _o.once "stopped", cb 

        # Start the program..
        _o.start( )

exports.shell = shell
