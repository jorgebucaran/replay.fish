set -g bax_version 1.0.0

complete -xc bax -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc bax -n __fish_use_subcommand -a --version -d "$bax_version"

function bax
    switch "$argv"
        case {,-}-h{elp,} ""
            echo "usage: bax <bash commands>    Run a bash command"
            echo "       bax --help             Show this help"
            echo "       bax --version          Show the current version"
        case {,-}-v{ersion,}
            echo "bax version $bax_version"
        case \*
            set -l delim "@@@@bax@@@@"
            command bash -c "
                $argv
                status=\$?
                [ \$status -eq 0 ] && echo $delim && alias && echo $delim && command awk '
                    BEGIN {
                        for (k in ENVIRON)
                            if (gsub(/\n/, \"\\\n\", ENVIRON[k]) >= 0)
                                print k, ENVIRON[k]
                    }
                ' || echo $delim \$status
            " | command awk -v delim="$delim" '
                $0 != delim || !++i {
                    if ($1 == delim) exit $2
                    else if (i < 2) print (i ? $0 : gsub(/\$/, "\\\$") >= 0 ? "echo \"" $0 "\"" : "")
                    else env[$1] = (gsub(/\\\n/, "\n") >= 0 ? substr($0, length($1) + 2) : "")
                }
                END {
                    for (k in env)
                        if (len++ && k !~ /^(_|SHLVL|PS1|XPC_SERVICE_NAME|AWK(LIB)?PATH)$|^BASH_FUNC/\
                        && !(k in ENVIRON && ENVIRON[k] == env[k]))
                            print (\
                                k == "PATH" && gsub(/:/, "\" \"", env[k]) >= 0\
                                    ? "set PATH \"" env[k] "\"" : k == "PWD"\
                                    ? "cd \"" env[k] "\"" : "set -gx " k " \"" env[k] "\""\
                            )
                    if (!len) print "exit " $2
                    else for (k in ENVIRON) if (!(k in env)) print "set -e " k
                }
            ' | source
    end
end
