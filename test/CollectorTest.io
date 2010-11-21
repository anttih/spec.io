
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

