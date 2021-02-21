using StatsBase

export summarize

NestedTuples.summarize(ch::Chain) = summarize(value(ch))
