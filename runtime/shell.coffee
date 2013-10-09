log     = require( "logging" ).from __filename
coffee  = require "coffee-script"
orange  = require "../orange"

fs      = require "fs"
path    = require "path"

class shell extends orange.OrangeRunnable

    start: ( args, cb ) ->
        log "Starting shell"
        super cb

        @runtime_loop( )

    prompt: ( ) ->
        _cwd = @environment.get "cwd"
        
        @out.write "#{@_id}:#{_cwd}>"

    parse_and_run: ( input, cb ) ->

        # Builtins..
        if input is "quit"
            log "Stopping.."
            return @stop( )


        # Find the path of the given coffee file.. or keep the _valid_path set
        # to false.
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

    runtime_loop: ( ) ->
        @prompt( )

        @in.on "data", ( chunk ) =>
            input = chunk.toString( ).replace RegExp( "\n$"), ""
            if input is ""
                return @prompt()

            @parse_and_run input, ( ) =>
                @prompt( )

exports.shell = shell
