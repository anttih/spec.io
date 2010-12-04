
describe("empty spec") do(
    before(s := Spec describe("Spec"))

    it("has no sub specs", s sub should be_empty)
    it("has no tests", s tests should be_empty)
    it("has name", s name should equal("Spec"))
    it("has no before hook", s hook_before should be_nil)
)

describe("spec with one test") do(
    before(
        s := Spec describe("Spec") do(
            it("Test name", nil)
        )
    )

    it("has one test", s should have(1) tests)
    it("has has test with name",
        s tests at(0) at(0) should equal("Test name")
    )

    it("has test which is a message",
        s tests at(0) at(1) type should equal("Message")
    )
)

describe("spec with nested spec") do(
    before(
        s := Spec describe("Spec") do(
            describe("Nested") do(
                it("Test name", nil)
            )
        )
    )

    it("has spec with name", s sub at(0) name should equal("Nested"))
    it("has one nested spec", s should have(1) sub)
    it("has one nested test", s sub at(0) should have(1) tests)
    it("has one nested test with name and message",
        test := s sub at(0) tests at(0)
        test at(0) should equal("Test name")
        test at(1) type should equal("Message")
    )
    it("has parent as proto",
        assert(s sub at(0) ancestors at(1) hasProto(s))
    )
)

describe("spec with deeply nested specs") do(
    before(
        s := Spec describe("Spec") do(
            describe("Nested") do(
                describe("Deep")
            )
        )
    )

    it("has deeply nested spec", s sub at(0) should have(1) sub)
    it("has deeply nested spec with name",
        s sub at(0) sub at(0) name should equal("Deep")
    )
)

describe("spec with before") do(
    before(
        s := Spec describe("Spec") do(
            before(Nop)
        )
    )

    it("has before message", s hook_before type should equal("Message"))
)

describe("putting code as second param to describe") do(
    before(
        s := Spec describe("Spec name", it("test name", Nop))
    )

    it("should work the same as do()",
        s should have(1) tests
    )
)
