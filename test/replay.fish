@mesg $current_filename

@test "stdout" (
    replay echo foo bar
    replay echo replay fum
) = "foo bar replay fum"

@test "export" (
    replay export _replay=foo
    command env | command awk '/^_replay=/'
) = "_replay=foo"

@test "unset" (
    replay unset _replay
    set -q _replay
) $status -eq 1

@test "\$PATH" (
    replay "PATH=\$PATH:_replay"
    echo $PATH[-1]
    set -e PATH[-1]
) = _replay

@test "alias" (
  replay alias _replay_pwd=pwd
  _replay_pwd
) = (pwd)

@test "cd" (
    set -l cwd (pwd)
    replay cd /
    pwd
    cd "$cwd"
) = /

@test "exit status" (
    replay 'die() { return 123; }; die'
) $status -eq 123

@test "semi" (
    replay export "_replay=semi;"
    command env | command awk '/^_replay=/'
) = _replay=semi

@test "dollar" (replay echo \$) = \$
