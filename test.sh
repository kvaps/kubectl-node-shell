#!/bin/bash
run_test() {
  local name=$1
  local node=$2
  local script=$3
  echo "==== test: $1 (node: $2) ===="

  local expected="$(mktemp)"
  local got="$(mktemp)"
  
  if diff --strip-trailing-cr -u <(sh -c "$script") <(set -x; ./kubectl-node_shell $node -- sh -c "$script"); then
    echo -e "Result: \e[42mPASS\e[49m"
  else
    echo -e "Result: \e[101mFAIL\e[49m"
  fi

  rm -f "$expected" "$got"
}

if [ -z $1 ]; then
  echo "please specify node in first argument" >&2
  exit -1
fi

case1=$(cat <<\EOT
echo $(echo "
hello everybody
I'm a \"baby seal\""

)
EOT
)

case2=$(cat <<\EOT

echo "ggg


ttt"
EOT
)

case3=$(cat <<\EOT
echo $(echo "
hello everybody
I'm a \"baby seal

really really

\""
)
EOT
)

run_test "case 1" "$1" "$case1"
run_test "case 2" "$1" "$case2"
run_test "case 3" "$1" "$case3"
