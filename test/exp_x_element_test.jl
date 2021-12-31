#exp_x_element_test.jl
#Description:
#   Test the new type definition for EXP_X_Element.

using Test

include("system.jl")
include("cover.jl")
include("exp_x_element.jl")


"""
Test 1: v,q, and c
"""

# Test 1a: v

tempv = Vector{String}(["y1","u1","y2","u1","y3"])
tempq = Vector{String}(["x1","x2","x3"])
tempc = Vector{String}(["x1","x2"])

tempEXPxElt = EXP_X_Element((tempv,tempq,tempc))

@test tempEXPxElt.v == tempv
@test tempEXPxElt.q == tempq
@test tempEXPxElt.c == tempc

"""
Test 2: GetInitialEXP_X
"""

# Test 1: Each State Has Unique output

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
println( Set(["q0","q2","q3","q2"]) )
for x in Set(["q0","q2","q3","q4"])
    println(x)
end
println( convert(Vector{String},Set(["q0","q2","q3","q4"])) )

EXP_X1 = GetInitialEXP_X(sys1a,cover1)

@test length(EXP_X1) == 1
@test EXP_X1[1] == EXP_X_Element( ( Vector{String}(["y2"]) , Vector{String}(["q0"]) , Vector{String}(["q0"]) ) )