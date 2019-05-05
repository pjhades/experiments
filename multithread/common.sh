assert() {
    local result="$(tr -d '\n' <<<$1)"
    local expected="$(tr -d '\n' <<<$2)"
    if [ "$result" != "$expected" ]; then
        echo "test failed: got $result, expected $expected"
    fi
}
