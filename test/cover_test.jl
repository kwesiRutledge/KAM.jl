#cover_test.jl
#Description:
#   

using Test

include("../src/KAM.jl")

# Functions

"""
Test #1
"""

# Test1a: Basic CreateCover test where each state gave individual unique outputs

sys1a = System(
    ["q0","q1","q3"], 
    ["q0"], 
    ["o1","o2"], 
    [
        sparse([2,2],[2,3],[1,1]),
        sparse([1,2,2],[2,2,3],[1,1,1]),
        sparse([1,2],[1,2],[1,1])
    ],
    ["y1","y2","y3"],
    sparse([1,2,3],[2,3,1],[1,1,1])
)

cover1 = CreateCover(sys1a)
@test cover1[1] == ["q3"]
@test cover1[2] == ["q0"]
@test cover1[3] == ["q1"]

# Test1b: CreateCover test. One output associated with multiple states.

sys1b = System(
    ["q0","q1","q2","q3"], 
    ["q0"], 
    ["o1","o2"], 
    [
        sparse([2,2],[2,3],[1,1]),
        sparse([1,2,2],[2,2,3],[1,1,1]),
        sparse([1,2],[1,2],[1,1])
    ],
    ["y1","y2","y3"],
    sparse([1,2,3,4],[2,3,1,1],[1,1,1,1])
)

cover2 = CreateCover(sys1b)
@test cover2[1] == ["q2","q3"]
@test cover2[2] == ["q0"]
@test cover2[3] == ["q1"]

# Test1c: CreateCover test for system where one state has multiple outputs

sys1c = System(
    ["q0","q1","q2","q3"], 
    ["q0"], 
    ["o1","o2"], 
    [
        sparse([2,2],[2,3],[1,1]),
        sparse([1,2,2],[2,2,3],[1,1,1]),
        sparse([1,2],[1,2],[1,1])
    ],
    ["y1","y2","y3"],
    sparse([1,2,3,4,4],[2,3,1,1,2],[1,1,1,1,1])
)

cover3 = CreateCover(sys1c)
@test cover3[1] == ["q2","q3"]
@test cover3[2] == ["q0","q3"]
@test cover3[3] == ["q1"]