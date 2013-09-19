log     = require( "logging" ).from __filename
orange  = require "./orange"
shell   = require "./runtime/shell"

process.stdin.resume( )

env = new orange.OrangeEnvironment
env.set "cwd", "/tmp"

# Start a shell in that environment, using stdin and stdout.
yas = new shell.Shell env, process.stdout, process.stdin 
yas.start ( ) ->
    log "Started yas shell!"

yas.on "stopped", ( ) ->
    log "YAS has stopped!"

