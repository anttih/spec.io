Spec

ReporterStub := Object clone do(
    init := method(
        self okMessage := list()
        self errorMessage := list()
        self failureMessage := list()
        self doneMessage := list()
    )
    ok := method(self okMessage append(call evalArgs))
    error := method(self errorMessage append(call evalArgs))
    fail := method(self failureMessage append(call evalArgs))
    done := method(self doneMessage append(call evalArgs))
)

BaseTest := UnitTest clone do(
    withSpec := method(spec,
        self spec := spec
    )

    setUp := method(
        self runner := Spec Runner with(self spec)
        self reporter := ReporterStub clone
        runner setReporter(reporter)
        runner run
    )
)

SpecWithNoTests := BaseTest clone do(
    withSpec(Spec describe("No errors"))

    test_should_normalize_to_list_of_contexts := method(
        assert(runner suite isKindOf(List))
    )

    test_has_no_errors := method(
        assertEquals(runner errors size, 0)
    )
    
    test_has_no_failures := method(
        assertEquals(runner failures size, 0)
    )

    test_never_reports_ok := method(
        assertEquals(reporter okMessage size, 0)
    )

    test_reports_done_with_no_errors_and_failures := method(
        args := reporter doneMessage at(0)
        assertEquals(args at(0) size, 0)
        assertEquals(args at(1) size, 0)
    )
)

SpecWithOneSuccessfulTest := BaseTest clone do(
    withSpec(Spec describe("Spec") do(it("Success", nil)))

    test_reports_ok_once := method(
        assertEquals(reporter okMessage size, 1)
        assert(reporter okMessage at(0) == list(list("Spec"), "Success"))
    )
)

SpecWithNestedSuccessfulTest := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        describe("Nested") do(it("Inner test", nil))
    ))

    test_reports_ok_with_full_context := method(
        assertEquals(
            reporter okMessage at(0) at(0),
            list("Spec", "Nested")
        )
    )

    test_reports_ok_with_test_name := method(
        assertEquals(
            reporter okMessage at(0) at(1),
            "Inner test"
        )
    )
)

SpecWithTwoSuccessfulTests := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        it("Test one", nil)
        it("Test two", nil)
    ))

    test_reports_ok_twice := method(
        assert(reporter okMessage size == 2)
    )

    test_reports_ok_with_correct_context := method(
        assertEquals(reporter okMessage at(0) at(0), list("Spec"))
        assertEquals(reporter okMessage at(1) at(0), list("Spec"))
    )

    test_reports_ok_with_correct_test_name := method(
        assertEquals(reporter okMessage at(0) at(1), "Test one")
        assertEquals(reporter okMessage at(1) at(1), "Test two")
    )
)

SpecWithNestedTests := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        it("Parent test", nil)
        describe("nested") do(
            it("Inner test", nil)
        )
    ))

    test_reports_first_test := method(
        params := reporter okMessage at(0)
        assertEquals(params at(0), list("Spec"))
        assertEquals(params at(1), "Parent test")
    )

    test_reports_inner_test := method(
        params := reporter okMessage at(1)
        assertEquals(params at(0), list("Spec", "nested"))
        assertEquals(params at(1), "Inner test")
    )
)

SpecWithSeveralNestedContexts := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        it("Parent test", nil)
        describe("nested") do(
            it("Inner test", nil)
        )
        describe("second nested") do(
            it("Second Inner test", nil)
        )
    ))

    test_reports_second_context_name := method(
        params := reporter okMessage at(2)
        assertEquals(params at(0), list("Spec", "second nested"))
        assertEquals(params at(1), "Second Inner test")
    )
)

SpecWithOneError := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        it("Erroring test", Exception raise("Message"))
    ))

    test_has_one_error := method(
        assertEquals(runner errors size, 1)
    )

    test_reports_one_error := method(
        assertEquals(reporter errorMessage size, 1)
    )

    test_reports_error_with_context_and_test := method(
        params := reporter errorMessage at(0)
        assertEquals(params at(0), list("Spec"))
        assertEquals(params at(1), "Erroring test")
    )

    test_reports_error_with_exception := method(
        params := reporter errorMessage at(0)
        assertEquals(params at(2) type, "Exception")
    )
)

SpecWithOneFailure := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        it("Failing test", AssertionException raise("Failure"))
    ))

    test_has_one_failure := method(
        assertEquals(runner failures size, 1)
    )

    test_reports_one_failure := method(
        assert(reporter failureMessage size == 1)
    )

    test_reports_failure_with_context := method(
        assertEquals(reporter failureMessage at(0) at(0), list("Spec"))
    )

    test_reports_failure_with_test_name := method(
        assertEquals(reporter failureMessage at(0) at(1), "Failing test")
    )

    test_reports_failure_with_exception := method(
        assertEquals(reporter failureMessage at(0) at(2) type, "AssertionException")
    )
)
