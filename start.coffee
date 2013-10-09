log     = require( "logging" ).from __filename
orange  = require "./orange"
shell   = require "./runtime/shell"

# Define a new environment. 
env = new orange.OrangeEnvironment

# Populate the environment with some random data..
env.set "cwd", process.cwd( )
env.set "path", [ "runtime/" ]

# Start a shell in that environment, using stdin and stdout.
process.stdin.resume( )
yas = new shell.shell env, process.stdin, process.stdout, process.stderr

yas.start null, ( ) ->
    log "Started yas shell!"

yas.once "stopped", ( ) ->
    log "YAS has stopped!"
    process.stdin.pause( )
