#exp_x_element_test.jl
#Description:
#   Test the new type definition for EXP_X_Element.

using Test

include("../src/KAM.jl")

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
EXP_X1 = GetInitialEXP_X(sys1a,cover1)

@test length(EXP_X1) == 1
@test EXP_X1[1] == EXP_X_Element( ( Vector{String}(["y2"]) , Vector{String}(["q0"]) , Vector{String}(["q0"]) ) )

# Test 2: Multiple initial states, with same output

sys2 = System(
    ["q0","q1","q2","q3"], 
    ["q0","q2"], 
    ["o1","o2"], 
    [
        sparse([2,2],[2,3],[1,1]),
        sparse([1,2,2],[2,2,3],[1,1,1]),
        sparse([1,1,2],[2,4,3],[1,1,1]),
        sparse([1,2],[1,2],[1,1])
    ],
    ["y1","y2","y3"],
    sparse([1,2,3,4],[2,3,2,1],[1,1,1,1])
)

cover2 = CreateCover(sys2)
EXP_X2= GetInitialEXP_X(sys2,cover2)

@test length(EXP_X2) == 1
@test EXP_X2[1] == EXP_X_Element( ( Vector{String}(["y2"]) , Vector{String}(["q0","q2"]) , Vector{String}(["q0","q2"]) ) )

# Test 3: Multiple initial states, with different outputs

sys3 = System(
    ["q0","q1","q2","q3","q4"], 
    ["q0","q1","q2"], 
    ["o1","o2"], 
    [
        sparse([2,2],[2,3],[1,1]),
        sparse([1,2,2],[2,2,3],[1,1,1]),
        sparse([1,1,2],[2,4,3],[1,1,1]),
        sparse([1,2],[1,2],[1,1])
    ],
    ["y1","y2","y3"],
    sparse([1,2,3,4,5],[2,3,2,1,2],[1,1,1,1,1])
)

cover3 = CreateCover(sys3)
EXP_X3= GetInitialEXP_X(sys3,cover3)

@test length(EXP_X3) == 2
@test EXP_X3[1] == EXP_X_Element( ( Vector{String}(["y2"]) , Vector{String}(["q0","q2","q4"]) , Vector{String}(["q0","q2"]) ) )
@test EXP_X3[2] == EXP_X_Element( ( Vector{String}(["y3"]) , Vector{String}(["q1"]) , Vector{String}(["q1"]) ) )

"""
Test 3: ProjectToGammaSet
"""

exp_x1 = EXP_X_Element( (Vector{String}(["woah"]),["typo"],["typo"]) )
exp_x2 = EXP_X_Element( (["tvShow"],["walkingDead"],["walkingDead"]) )

EXP_X1 = Vector{EXP_X_Element}([exp_x1,exp_x2])
project1 = ProjectToGammaSet(EXP_X1)

@test project1[1] == EXP_Gamma_Element( (["typo"],["typo"]) )
@test project1[2] == EXP_Gamma_Element( (["walkingDead"],["walkingDead"]) )
