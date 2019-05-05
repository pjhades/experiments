#!/bin/bash

set -o errexit -o pipefail

source ./common.sh

OUTPUT=output
QCAP=100

assert_sorted() {
    local list=$1
    assert "$list" "$(sort --qsort -n <<<$list)"
}

validate() {
    echo 'validate'
    for ((items = 10; items <= 1000000; items *= 10)); do
        echo -n "qcap=$QCAP items=$items ... "
        ./bounded-spmc-queue $QCAP $items >$OUTPUT
        assert $(grep producer $OUTPUT | wc -l) $items
        assert $(grep consumer $OUTPUT | wc -l) $items
        assert_sorted $(grep 'consumer1' $OUTPUT | awk '{print $2}') 
        assert_sorted $(grep 'consumer2' $OUTPUT | awk '{print $2}') 
        echo ok
    done
}

timing() {
    echo 'timing'
    for ((items = 10; items <= 1000000; items *= 10)); do
        echo -n "qcap=$QCAP items=$items ... "
        time ./bounded-spmc-queue $QCAP $items >/dev/null
    done
}

validate
timing
