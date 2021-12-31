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

"""
Test 2: IsMinimalCoverElement()
"""

# Cover2a: Tests an element that is a cover element
cover2a = Vector{Vector{String}}([
    Vector{String}(["x1","x2","x3"]),
    Vector{String}(["x3","x4","x5"])
    ])

c_prime = cover2a[1]

@test IsMinimalCoverElement(c_prime,cover2a)

# Cover2b: Tests an element that is NOT a cover element
cover2b = Vector{Vector{String}}([
    Vector{String}(["x1","x2","x3"]),
    Vector{String}(["x1","x2"]),
    Vector{String}(["x3","x4","x5"])
    ])

c_prime = cover2b[1]

@test !IsMinimalCoverElement(c_prime,cover2b)

"""
Test 3: GetMinimalCoverElementsContaining()
"""

# Cover3a: Tests a simple example which should choose a single cover element.
cover3a = Vector{Vector{String}}([
    Vector{String}(["x1","x2","x3"]),
    Vector{String}(["x3","x4","x5"])
    ])

c_prime = cover2a[1]
minimalElts3a = GetMinimalCoverElementsContaining(c_prime,cover3a)
@test length(minimalElts3a) == 1
@test minimalElts3a[1] == c_prime

# Cover3b: Tests a simple example where two cover elements will be returned.

c_prime = Vector{String}(["x3"])
minimalElts3a = GetMinimalCoverElementsContaining(c_prime,cover3a)
@test length(minimalElts3a) == 2
@test Set(minimalElts3a) == Set(cover3a)

# Cover 3c: Tests a simple example where a minimal cover set will invalidate the two matching cover elements.
cover3c = Vector{Vector{String}}([
    Vector{String}(["x1","x2","x3"]),
    Vector{String}(["x1","x2"]),
    Vector{String}(["x3","x4","x5"])
    ])

c_prime = cover3c[2]

minimalElts3c = GetMinimalCoverElementsContaining(c_prime,cover3c)
@test length(minimalElts3c) == 1
@test minimalElts3c[1] == c_prime

