
Spec do(
    Runner with(
        DirectoryCollector with("./examples") collect
    ) setReporter(SilentReporter clone) run
)
