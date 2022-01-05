#exp_gamma_element_test.jl
#Description:
#   Test the new type definition for EXP_Gamma_Element.

using Test

include("../src/KAM.jl")

"""
Test 1
"""

# Test 1a: Convert EXP_Gamma_Element to an EXP_Gamma_Element

tempv = Vector{String}(["y1","u1","y2","u1","y3"])
tempq = Vector{String}(["x1","x2","x3"])
tempc = Vector{String}(["x1","x2"])

tempEXPxElt = EXP_X_Element((tempv,tempq,tempc))
newEXPGElt = EXP_Gamma_Element( tempEXPxElt )

@test tempEXPxElt.q == newEXPGElt.q
@test tempEXPxElt.c == newEXPGElt.c

"""
Test 2: ChangeAllInstancesOfElement!
"""

# 2a: Change single element in list.

exp_g_elt_2a = EXP_Gamma_Element( (["typo"],["typo"]) )
EXP_Gamma_2a = Vector{EXP_Gamma_Element}([
    exp_g_elt_2a,
    EXP_Gamma_Element( (["walkingDead"],["walkingDead"]) ),
    EXP_Gamma_Element( (["it"],["out"]) )
])

EXP_Gamma_2a_copy = copy(EXP_Gamma_2a)

exp_g_elt_2a_target = EXP_Gamma_Element( (["typo1"] , exp_g_elt_2a.c) )

ChangeAllInstancesOfElement!(EXP_Gamma_2a_copy, exp_g_elt_2a , exp_g_elt_2a_target)

@test exp_g_elt_2a_target == EXP_Gamma_2a_copy[1]
@test Set(EXP_Gamma_2a) != Set(EXP_Gamma_2a_copy)

# 2b: Change no elements in list.

exp_g_elt_2b = EXP_Gamma_Element( (["matrix"],["matrix"]) )
EXP_Gamma_2b = Vector{EXP_Gamma_Element}([
    EXP_Gamma_Element( (["typo"],["typo"]) ),
    EXP_Gamma_Element( (["walkingDead"],["walkingDead"]) ),
    EXP_Gamma_Element( (["it"],["out"]) )
])

EXP_Gamma_2b_copy = copy(EXP_Gamma_2b)

exp_g_elt_2b_target = EXP_Gamma_Element( ( ["typo1"] , exp_g_elt_2b.c) )

ChangeAllInstancesOfElement!(EXP_Gamma_2b_copy, exp_g_elt_2b , exp_g_elt_2b_target)

@test exp_g_elt_2b_target != EXP_Gamma_2b[1]
@test Set(EXP_Gamma_2b) == Set(EXP_Gamma_2b_copy)