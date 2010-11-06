
Isolate := Object clone do(
    forward := method(
        "getSlot(#{thisMessage name})" interpolate println
    )

    getSlot := method(name,
        "getSlot(#{name})" interpolate println
    )

    hello := method("Hello" println)
)

Some := Object clone do(
    hello := method("Hello from Some" println)
)

//Lobby do(
//    _forward := Lobby getSlot("forward")
//    _getSlotOrig := Lobby getSlot("getSlot")
//
//    forward := method(
//        thisMessage name println
//        self _forward call(thisMessage arguments)
//    )
//
//    getSlot := method(name,
//        "Lobby getSlot(#{name})" interpolate println
//    )
//)

Hello := Object clone do(say := method("say hello" println))

Object clone do(
    getSlot := method(name, "getSlot(#{name})" interpolate println)
    forward := method(call message println; resend)
    hello := method("hello" println)
    moi
)

