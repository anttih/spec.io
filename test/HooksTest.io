Spec
doRelativeFile("./RunnerTest.io")

SpecWithBefore := BaseTest clone do(
    withSpec(Spec describe("Spec") do(
        before_count := 0
        someslot := false
        before(context before_count = 1; someslot := "value")
        it("First", context someslot = someslot)
    ))

    test_runs_before_once := method(
        assertEquals(spec before_count, 1)
    )

    test_before_runs_in_same_scope := method(
        assertEquals(spec someslot, "value")
    )
)
