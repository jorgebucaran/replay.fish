@test stdout (
    replay echo "foo bar piyo poyo"
) = "foo bar piyo poyo"

@test export (
    replay export _replay=foo
    command env | string match --entire --regex -- "^_replay"
) = "_replay=foo"

@test unset (
    replay unset _replay
    set --query _replay
) $status -eq 1

@test \$PATH (
    replay "PATH=\$PATH:_replay"
    echo $PATH[-1]
    set --erase PATH[-1]
) = _replay

@test aliases (
  replay alias _replay_pwd=pwd
  _replay_pwd
) = (pwd)

@test \$PWD (
    set --local cwd (pwd)
    replay cd /
    pwd && cd "$cwd"
) = /

@test "\$?" (
    replay "finish() { return 42; }; finish"
) $status -eq 42

@test \$ (replay echo \$) = \$

@test ";" (
    replay export "_replay=semi;"
    command env | string match --entire --regex -- "^_replay"
) = _replay=semi
