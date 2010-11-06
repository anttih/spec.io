
SilentReporterTest := UnitTest clone do(
    setUp := method(
        self reporter := SilentReporter clone do(
            buffer := list()
            writeln := method(seq, buffer append(seq))
        )
    )

    tearDown := method(
        reporter removeSlot("writeln")
    )

    test_writes_failures := method(
        e := try(AssertionException raise("Message"))
        reporter fail(list("Spec"), "test name", e)
        file := File thisSourceFile path
        line := e coroutine callStack at(0) message lineNumber
        assertEquals(
            self reporter buffer at(0),
            "FAIL: Message. File #{file}, line #{line}." interpolate
        )
    )

    test_writes_errors := method(
        e := try(Exception raise("Message"))
        reporter error(list("Spec"), "test name", e)
        file := File thisSourceFile path
        line := e coroutine callStack at(0) message lineNumber
        assertEquals(
            self reporter buffer at(0),
            "ERROR: Message. File #{file}, line #{line}." interpolate
        )
    )
)
