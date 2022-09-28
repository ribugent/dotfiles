# This cannot be called due slowness
# See bug: https://github.com/databrickslabs/dbx/issues/494
# dbx --show-completion fish | source

# As workarround here's the output of previous command
complete --command dbx --no-files --arguments "(env _DBX_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=get-args _TYPER_COMPLETE_ARGS=(commandline -cp) dbx)" --condition "env _DBX_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=is-args _TYPER_COMPLETE_ARGS=(commandline -cp) dbx"
