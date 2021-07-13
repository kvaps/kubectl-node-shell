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

case=()

case[1]=$(cat <<\EOT
echo $(echo "
hello everybody
I'm a \"baby seal\""

)
EOT
)

case[2]=$(cat <<\EOT

echo "ggg


ttt"
EOT
)

case[3]=$(cat <<\EOT
echo $(echo "
hello everybody
I'm a \"baby seal

really really

\""
)
EOT
)

case[4]="$(echo -e echo "\e[42mHOLA\e[49m")"

for i in $(seq 1 ${#case[@]}); do
  run_test "case $i" "$1" "${case[$i]}"
done
