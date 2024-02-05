# AWS completions
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

if test (uname) = "Darwin"
    set -x fish_complete_path $fish_complete_path /opt/homebrew/opt/curl/share/fish/vendor_completions.d
end
