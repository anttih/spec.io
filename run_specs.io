
Spec do(
    Runner with(
        DSLDirectoryCollector with("spec") collect
    ) setReporter(SilentReporter clone) run
)
