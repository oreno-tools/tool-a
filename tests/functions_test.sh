#!/usr/bin/env bash
# filename: functions_test.sh

source ../functions.sh

testIncho() {
  output=$(incho test)
  except=$(printf "\e[34mtest\e[m\n")
  assertEquals ${output} ${except}
}

testWacho() {
  output=$(wacho test)
  except=$(printf "\e[33mtest\e[m\n")
  assertEquals ${output} ${except}
}

testContinueSelectNo() {
  output=$(echo n | continue?)
  except="処理を中断します."
  assertEquals "${output}" "${except}"
}

testContinueIgnoreOption() {
  output=$(echo p | continue?)
  except="Please answer YES or NO."
  assertEquals "${output}" "${except}"
}

testReadVariablesIgnoreOption() {
  output=$(read_variables test.yml)
  except=$(printf "\e[33m設定ファイルを読み込めません.\e[m\n")
  assertEquals "${output}" "${except}"
}

# shUnit2 は最後に読み込んであげる必要がある
. ./shunit2
