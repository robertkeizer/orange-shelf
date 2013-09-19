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
yas = new shell.Shell env, process.stdin, process.stdout

yas.start ( ) ->
    log "Started yas shell!"

yas.on "stopped", ( ) ->
    log "YAS has stopped!"
