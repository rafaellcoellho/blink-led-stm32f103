all: tests runnable

analysis:
	make -f MakeAnalysis.mk V=${V} all

runnable:
	make -f MakeRunnable.mk V=${V} all

tests:
	make -f MakeTests.mk V=${V} all

tests_coverage:
	make -f MakeTests.mk V=${V} coverage

flash:
	st-flash write blink_led.bin 0x8000000

erase:
	st-flash erase
	
clean:
	make -f MakeRunnable.mk V=${V} clean
	make -f MakeTests.mk V=${V} clean
	make -f MakeTests.mk V=${V} coverage_clean
	@ rm -rf ./build/objs/ ./build/lib/
