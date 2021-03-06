Spec
doRelativeFile("./RunnerTest.io")

SpecWithBefore := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        before_count := 0
        someslot := false
        before(before_count = 1; someslot = "value")
        it("First", someslot_value := someslot)
    ))

    test_runs_before_once := method(
        assertEquals(spec before_count, 1)
    )

    test_before_runs_in_same_scope := method(
        assertEquals(spec someslot_value, "value")
    )
)

SpecWithNestedBefores := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        before(say := "first")
        it("Test one", Nop)
        describe("Nested") do(
            before(say = say .. " second")
            it("Test two", Nop)
        )
    ))

    test_runs_both_tests_in_order := method(
        assertEquals(spec sub at(0) say, "first second")
    )
)
