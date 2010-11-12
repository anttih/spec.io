
Spec := Object clone do(
    describe := method(name,
        spec := Context clone
        spec name = name
        spec
    )
)

Context := Object clone do(
    init := method(
        self name := nil
        self tests := list()
        self sub := list()
    )

    describe := method(name,
        spec := Context clone
        spec name = name
        sub append(spec)
        spec
    )

    it := method(name,
        tests append(list(name, call argAt(1)))
    )
)

Runner := Object clone do(

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
        suite foreach(context, _runContext(context))
    )

    _runContext := method(context,
        stack append(context)
        # list of context names
        path := stack map(name)
        context tests foreach(test,
            e := try(
                self doMessage(test at(1))
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

SilentReporter := Object clone do(
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
