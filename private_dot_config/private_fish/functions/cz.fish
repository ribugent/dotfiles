function cz --wraps=chezmoi --description 'alias cz chezmoi with \'cd\' catching'
  switch $argv[1]
    case 'cd'
      cd (chezmoi source-path)
    case '*'
      chezmoi $argv
  end
end
