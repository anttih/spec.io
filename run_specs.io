
Spec do(
    Runner with(
        DSLDirectoryCollector with("spec") collect
    ) setReporter(StoryReporter clone) run
)
