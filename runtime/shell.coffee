orange = require "../orange"

class Shell extends orange.OrangeRunnable

    constructor: ( @environment, @out, @in ) ->

        super( )

        # Optionally hook into any environment changes we care
        # about.
        @environment.on "updated", ( what ) ->
            log "Shell noticed that #{what} changed."

    start: ( cb ) ->
        if cb
            @addListener "started", cb

        @started( )

        @runtime_loop( )

    stop: ( cb ) ->
        if cb
            @addListener "stopped", cb

        @in.removeAllListeners

        @stopped( )

    prompt: ( ) ->
        _cwd = @environment.get "cwd"
        
        @out.write "#{@_id}:#{_cwd}>"

    parse_and_run: ( input ) ->
        @out.write "\nWould parse '#{input}' as a command.\n"

    runtime_loop: ( ) ->
        @out.write "\n"
        @prompt( )

        @in.on "data", ( chunk ) =>
            input = chunk.toString( ).replace RegExp( "\n$"), ""
            if input is ""
                return @prompt()

            @parse_and_run input
            @prompt( )

        @in.on "end", ( ) =>
            @stop( )

exports.Shell = Shell
