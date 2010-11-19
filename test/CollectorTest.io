
EmptySpecTest := UnitTest clone do(
    setUp := method(
        self spec := Spec describe("Spec")
    )

    test_has_no_sub_specs := method(
        assertEquals(spec sub size, 0)
    )

    test_has_no_tests := method(
        assertEquals(spec tests size, 0)
    )

    test_spec_has_name := method(
        assertEquals(spec name, "Spec")
    )
)

SpecWithOneTest := UnitTest clone do(
    setUp := method(
        self spec := Spec describe("Spec") do(
            it("Test name", nil)
        )
    )

    test_has_one_test := method(
        assertEquals(spec tests size, 1)
    )

    test_test_has_name := method(
        assertEquals(spec tests at(0) at(0), "Test name")
    )

    test_test_is_a_message := method(
        assertTrue(spec tests at(0) at(1) type == "Message")
    )
)

SpecWithNestedSpec := UnitTest clone do(
    setUp := method(
        self spec := Spec describe("Spec") do(
            describe("Nested") do(
                it("Test name", nil)
            )
        )
    )

    test_spec_has_name := method(
        assertEquals(spec sub at(0) name, "Nested")
    )

    test_has_one_nested_spec := method(
        assertEquals(spec sub size, 1)
    )

    test_has_one_nested_test := method(
        assertEquals(spec sub at(0) tests size, 1)
    )

    test_nested_test_has_name_and_message := method(
        test := spec sub at(0) tests at(0)
        assertEquals(test at(0), "Test name")
        assertEquals(test at(1) type, "Message")
    )
)

SpecWithDeeplyNestedSpecs := UnitTest clone do(
    setUp := method(
        self spec := Spec describe("Spec") do(
            describe("Nested") do(
                describe("Deep")
            )
        )
    )

    test_has_deeply_nested_spec := method(
        assertEquals(spec sub at(0) sub size, 1)
    )

    test_spec_has_name := method(
        assertEquals(spec sub at(0) sub at(0) name, "Deep")
    )
)

SpecAsList := UnitTest clone do(
    setUp := method(
        self runner := Spec Runner with(list(
            Spec describe("Spec")
        ))
    )

    test_has_a_suite_with_one_spec := method(
        assert(runner suite size == 1)
        assert(runner suite at(0) type == "Context")
    )
)

LobbyCollectorTest := UnitTest clone do(
    test_collects_only_context_types_in_lobby := method(
        Lobby doRelativeFile("spec/TestSpec.io")
        suite := Spec LobbyCollector collect
        assertEquals(suite size, 1)
        assert(suite at(0) isKindOf(Spec Context))
    )
)

DirectoryCollectorTest := UnitTest clone do(
    
    test_collects_files_ending_in_spec := method(
        dir := Spec DirectoryCollector with(System launchPath ..  "/test/spec/testdir")
        suite := dir collect
        assertEquals(suite size, 1)
    )
)

if(isLaunchScript, FileCollector clone run)

