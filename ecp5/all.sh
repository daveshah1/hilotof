#!/usr/bin/env bash

result=0

for f in tests/*; do
	test=$(basename $f)
	echo "Building $test..."
	./build.sh $test > build/$1/build.log 2>&1
	build_result=$?
	if [ $build_result -ne 0 ]; then
		echo "***** Building $test failed, see build/$test/build.log"
		result=1
		continue
	fi
	echo "Running $test..."
	./run.sh $test > build/$test/run.log 2>&1
	test_result=$?
	if [ $test_result -ne 0 ]; then
		echo "***** $test failed, see build/$test/run.log"
		result=1
		continue
	fi
	echo "$test passed!"
done

exit $result
