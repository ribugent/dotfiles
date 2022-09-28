# This cannot be called due slowness
# dbx --show-completion fish | source

# Here's the output of previous command
complete --command dbx --no-files --arguments "(env _DBX_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=get-args _TYPER_COMPLETE_ARGS=(commandline -cp) dbx)" --condition "env _DBX_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=is-args _TYPER_COMPLETE_ARGS=(commandline -cp) dbx"
