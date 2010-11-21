Regex

ShouldTest := UnitTest clone do(
    assertFails := method(
        e := try(call evalArgAt(0))
        assert(
            e type == "AssertionException",
            "#{call argAt(0)} should have raised an error." interpolate
        )

        error := call evalArgAt(1)
        if(error isNil not, assertEquals(e error, error))
        e
    )

    test_should_returns_a_matcher_with_self_value := method(
        assertEquals(Object should type, "Matcher")
        assertEquals(Object should value, Object)
    )

    test_be_true_fails_for_false := method(
        assertFails(false should be_true)
    )

    test_be_true_succeeds_for_true := method(
        true should be_true
    )

    test_be_false_fails_for_true := method(
        assertFails(true should be_false)
    )

    test_be_false_succeeds_for_false := method(
        false should be_false
    )

    test_equal_fails_when_not_equal := method(
        assertFails(2 should equal(1))
    )

    test_equal_succeeds_when_equal := method(
        "This" should equal("This")
    )

    test_equal_has_custom_error_message := method(
        assertFails(2 should equal(1), "2 does not equal 1.")

        assertFails("Sequence" should equal(false), "\"Sequence\" does not equal false.")

        e := assertFails(Object clone should equal(false))
        assert(e error hasMatchOfRegex("^Object_0x[0-9a-f]{6} does not equal false.$"))
    )

    test_be_nil_fails_when_not_nil := method(
        assertFails(false should be_nil)
    )

    test_be_empty_fails_for_non_empty_list := method(
        assertFails(list(1) should be_empty, "Object is not empty, size is 1.")
    )

    test_be_empty_succeeds_for_empty_list := method(
        list() should be_empty
    )
)
