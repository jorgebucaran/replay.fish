@mesg $current_filename

@test "stdout" (
    bax echo foo bar
    bax echo bax fum
) = "foo bar bax fum"

@test "export" (
    bax export _bax=foo
    command env | command awk '/^_bax=/'
) = "_bax=foo"

@test "unset" (
    bax unset _bax
    set -q _bax
) $status -eq 1

@test "\$PATH" (
    bax "PATH=\$PATH:_bax"
    echo $PATH[-1]
    set -e PATH[-1]
) = _bax

@test "alias" (
  bax alias _bax_pwd=pwd
  _bax_pwd
) = (pwd)

@test "cd" (
    set -l cwd (pwd)
    bax cd /
    pwd
    cd "$cwd"
) = /

@test "exit status" (
    bax 'die() { return 123; }; die'
) $status -eq 123

@test "semi" (
    bax export "_bax=semi;"
    command env | command awk '/^_bax=/'
) = _bax=semi

@test "dollar" (bax echo \$) = \$
