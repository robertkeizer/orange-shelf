log     = require( "logging" ).from __filename
orange  = require "../orange"
fs      = require "fs"
path    = require "path"

class Shell extends orange.OrangeRunnable

    start: ( cb ) ->
        super cb

        @runtime_loop( )

    prompt: ( ) ->
        _cwd = @environment.get "cwd"
        
        @out.write "#{@_id}:#{_cwd}>"

    parse_and_run: ( input ) ->

        _valid_path = false
        for _path in @environment.get( "path" )
            _possible_path = path.join _path, "#{input}.coffee"
            if fs.existsSync _possible_path
                _valid_path = _possible_path
                break

        if _valid_path isnt false
            @out.write "I found the command '#{input}' (#{_valid_path})\n"
        else
            @out.write "Unknown command.\n"

    runtime_loop: ( ) ->
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
