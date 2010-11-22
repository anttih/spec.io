
describe("SilentReporter") do(
    before(
        reporter := Spec SilentReporter clone do(
            buffer := list()
            writeln := method(seq, buffer append(seq))
        )
    )

    it("writes failures",
        e := try(AssertionException raise("Message"))
        reporter fail(list("Spec"), "test name", e)

        file := File thisSourceFile path
        line := e coroutine callStack at(0) message lineNumber

        reporter buffer at(0) should equal(
            "FAIL: Message. File #{file}, line #{line}." interpolate
        )
    )

    it("writes errors",
        e := try(Exception raise("Message"))
        reporter error(list("Spec"), "test name", e)

        file := File thisSourceFile path
        line := e coroutine callStack at(0) message lineNumber

        reporter buffer at(0) should equal(
            "ERROR: Message. File #{file}, line #{line}." interpolate
        )
    )
)

describe("Story reporter") do(
    before(
        reporter := Spec StoryReporter clone do(
            lines := list()
            writeln := method(seq, lines append(seq))
        )
    )

    assertLines := method(lines,
        reporter lines should equal(lines)
    )

    it("prints topic name if no topic printed",
        reporter ok(list("Spec name"), "Test name")
        reporter lines at(0) should equal(nil)
        reporter lines at(1) should equal("Spec name")
    )

    it("prints same topic name once",
        reporter ok(list("Spec name"), "Test name")
        reporter ok(list("Spec name"), "Test name 2")

        reporter should have(4) lines

        reporter lines at(0) should equal(nil)
        reporter lines at(1) should equal("Spec name")
        reporter lines at(2) should equal("  ✓ Test name")
        reporter lines at(3) should equal("  ✓ Test name 2")
    )

    it("separates topic with one blank line",
        reporter ok(list("Spec name"), "Test name")
        reporter ok(list("Spec name 2"), "Test name 2")

        reporter should have(6) lines

        reporter lines at(0) should equal(nil)
        reporter lines at(1) should equal("Spec name")
        reporter lines at(2) should equal("  ✓ Test name")
        reporter lines at(3) should equal(nil)
        reporter lines at(4) should equal("Spec name 2")
        reporter lines at(5) should equal("  ✓ Test name 2")
    )
)
