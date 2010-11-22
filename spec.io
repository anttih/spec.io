
Spec := Object clone do(
    init := method(
        self hook_before := nil

        self name := nil
        self tests := list()
        self sub := list()
    )

    describe := method(name,
        spec := self clone
        spec name = name
        # Make this method work as a "static" method
        # when the receiver is the type itself. That is, don't
        # make the newly created spec a sub-spec of the proto for
        # the first `Spec describe()`.
        if(self hasSlot("sub"), sub append(spec))
        spec
    )

    it := method(name,
        tests append(list(name, call argAt(1)))
    )

    before := method(hook_before = call argAt(0))
)

Spec Runner := Object clone do(

    init := method(
        self reporter ::= nil
        self suite := list()
        self failures := list()
        self errors := list()
        self stack := list() # context stack while running
    )

    with := method(suite,
        runner := self clone
        suite = if(suite isKindOf(List), suite, list(suite))
        runner suite = suite
        runner
    )

    run := method(
        _runSuite(suite)
        reporter ?done(failures, errors)
    )

    failure := method(path, test, e,
        failures append(list(path, test, e))
        reporter ?fail(path, test, e)
    )

    error := method(path, test, e,
        errors append(list(path, test, e))
        reporter ?error(path, test, e)
    )

    _runSuite := method(suite,
        suite foreach(context, _runSpec(context))
    )

    _runSpec := method(context,
        stack append(context)
        # list of context names
        path := stack map(name)
        context tests foreach(test,
            e := try(
                cont := Object clone
                cont context := context
                if(context hook_before isNil not,
                    cont doMessage(context hook_before)
                )

                cont doMessage(test at(1))
                reporter ?ok(path, test at(0))
            )

            e catch(AssertionException,
                failure(path, test at(0), e)
            ) catch(Exception,
                error(path, test at(0), e)
            )
        )

        _runSuite(context sub)
        stack pop
    )
)

Spec SilentReporter := Object clone do(
    fail := method(cont, name, e,
        context := cont join(" ")
        m := e coroutine callStack at(0) message
        file := m label
        line := m lineNumber
        self writeln("FAIL: #{e error}. File #{file}, line #{line}." interpolate)
    )

    error := method(cont, name, e,
        context := cont join(" ")
        m := e coroutine callStack at(0) message
        file := m label
        line := m lineNumber
        self writeln("ERROR: #{e error}. File #{file}, line #{line}." interpolate)
    )
)

Spec StoryReporter := Object clone do(
    init := method(
        self current := nil
    )

    ok := method(context, name,
        topic := context join("")
        if(topic != current,
            current = topic
            self writeln
            self writeln(topic)
        )
        self writeln("  ✓" .. (" #{name}" interpolate))
    )
)

Spec LobbyCollector := Object clone do(
    collect := method(
        suite := list()
        Lobby foreachSlot(slotName, slotValue,
            # a spec is an object which is not activatable,
            # is kind of Spec but is not the Spec root object.
            if(getSlot("slotValue") isActivatable not and \
               slotValue isKindOf(Spec) and slotValue != Spec,
                suite append(slotValue)
            )
        )
        suite
    )
)

Spec DirectoryCollector := Object clone do(
    path ::= nil

    with := method(path, setPath(path))

    testFiles := method(
        Directory with(path) files select(name endsWithSeq("Spec.io"))
    )

    collect := method(
        # do each file in a Spec
        suite := list()
        testFiles foreach(file,
            suite append(Spec describe(file name) doRelativeFile(file path))
        )
        suite
    )
)

Spec DSLDirectoryCollector := Object clone do(
    path ::= nil

    with := method(path, setPath(path))

    testFiles := method(
        Directory with(path) files select(name endsWithSeq(".spec.io"))
    )

    collect := method(
        # do each file in a Spec
        suite := list()
        testFiles foreach(file,
            spec := Spec describe(file name)
            spec doRelativeFile(file path)
            suite append(spec)
        )
        suite
    )
)

Spec Matcher := Object clone do(
    with := method(value,
        matcher := self clone
        matcher value := value
        matcher
    )

    be_true := method(
        equal(true)
    )

    be_false := method(
        equal(false)
    )

    be_nil := method(
        equal(nil)
    )

    be_empty := method(
        assert(
            value size == 0,
            "Object is not empty, size is #{value size}." interpolate
        )
    )

    equal := method(expected,
        assert(
            value == expected,
            "#{value asSimpleString} does not equal #{expected}." interpolate
        )
    )

    have := method(n,
        have_matcher := self with(value) do(
            forward := method(
                slot_name := call message name
                slot := value getSlot(slot_name)
                assert(
                    slot size == count,
                    "Object does not have exactly #{count} #{slot_name}." interpolate
                )
            )
        )
        have_matcher count := n
        have_matcher
    )
)

Object do(
    should := method(
        Spec Matcher with(self)
    )
)
