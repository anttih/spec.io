
ListSpec := Spec describe("List") do(
    it("has no items by default", assert(list() size == 0))

    describe("adding") do(
        it("adding one item adds size",
            l := list()
            l append(1)
            assert(l size == 1)
        )
    )
)

runner := Runner with(ListSpec)
runner setReporter(SilentReporter clone)
runner run
