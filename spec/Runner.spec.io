
ReporterStub := Object clone do(
    init := method(
        self okMessages := list()
        self errorMessages := list()
        self failureMessages := list()
        self doneMessages := list()
    )
    ok := method(self okMessages append(call evalArgs))
    error := method(self errorMessages append(call evalArgs))
    fail := method(self failureMessages append(call evalArgs))
    done := method(self doneMessages append(call evalArgs))
)

withSpec := method(spec, self spec := spec)

before(
    runner := Spec Runner with(spec)
    reporter := ReporterStub clone
    runner setReporter(reporter)
    runner run
)

describe("spec with no tests",
    withSpec(Spec describe("Empty"))

    it("normalizes to list of contexts",
        assert(runner suite isKindOf(List))
    )
    it("has no errors", runner should have(0) errors)
    it("has no failues", runner should have(0) failures)
    it("never reports ok", reporter should have(0) okMessages)
    it("reports done with no errors and failures",
        args := reporter doneMessages at(0)
        args at(0) size should equal(0)
        args at(1) size should equal(0)
    )
)

describe("spec with one successful test",
    withSpec(Spec describe("Spec",it("Success", nil)))

    it("reports ok once", reporter should have(1) okMessages)
    it("reports ok with context path and test name",
        reporter okMessages at(0) should equal(list(list("Spec"), "Success"))
    )
)

describe("spec with nested successful test",
    withSpec(Spec describe("Spec",
        describe("Nested",it("Inner test", nil))
    ))

    it("reports ok with context path and test name",
        f := reporter okMessages first
        f first should equal(list("Spec", "Nested"))
        f at(1) should equal("Inner test")
    )
)

describe("spec with two successful tests",
    withSpec(Spec describe("Spec",
        it("Test one", nil)
        it("Test two", nil)
    ))

    it("reports ok twice", reporter should have(2) okMessages)
    it("reports ok with context path for both tests",
        reporter okMessages first first should equal(list("Spec"))
        reporter okMessages at(1) first should equal(list("Spec"))
    )
    it("reports ok with correct test name for both",
        reporter okMessages first at(1) should equal("Test one")
        reporter okMessages at(1) at(1) should equal("Test two")
    )
)

describe("spec with nested tests",
    withSpec(Spec describe("Spec",
        it("Parent test", nil)
        describe("nested",
            it("Inner test", nil)
        )
    ))

    it("reports ok for first test",
        params := reporter okMessages at(0)
        params first should equal(list("Spec"))
        params at(1) should equal("Parent test")
    )

    it("reports ok with context path for inner test",
        reporter okMessages at(1) first should equal(list("Spec", "nested"))
    )

    it("reports ok with test name",
        reporter okMessages at(1) at(1) should equal("Inner test")
    )
)

describe("spec with several nested contexts",
    withSpec(Spec describe("Spec",
        it("Parent test", nil)
        describe("nested",
            it("Inner test", nil)
        )
        describe("second nested",
            it("Second Inner test", nil)
        )
    ))

    it("reports ok for second test in second context",
        params := reporter okMessages at(2)
        params at(0) should equal(list("Spec", "second nested"))
        params at(1) should equal("Second Inner test")
    )
)

describe("spec with one error",
    withSpec(Spec describe("Spec",
        it("Erroring test", Exception raise("Message"))
    ))

    it("has one error", runner should have(1) errors)
    it("reports one error", reporter should have(1) errorMessages)

    describe("reports error with",
        before(params := reporter errorMessages at(0))
        it("context", params at(0) should equal(list("Spec")))
        it("test", params at(1) should equal("Erroring test"))
        it("exception", params at(2) type should equal("Exception"))
    )
)

describe("spec with one failure",
    withSpec(Spec describe("Spec",
        it("Failing test", AssertionException raise("Failure"))
    ))

    it("has one failure", runner should have(1) failures)
    it("reports one failure", reporter should have(1) failureMessages)

    describe("reports failure with",
        before(params := reporter failureMessages at(0))
        it("context", params at(0) should equal(list("Spec")))
        it("test", params at(1) should equal("Failing test"))
        it("exception", params at(2) type should equal("AssertionException"))
    )
)

describe("spec with two tests referencing same slot",
    withSpec(Spec describe("Spec",
        first := ""
        it("First", first = first .. "hello")
        it("Second", first = first .. " world")
    ))

    it("shares that slot with both tests",
        spec first should equal("hello world")
    )
)
