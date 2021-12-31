#exp_gamma_element_test.jl
#Description:
#   Test the new type definition for EXP_Gamma_Element.

using Test

include("../src/KAM.jl")

"""
Test 1
"""

# Test 1a: Convert EXP_X_Element to an EXP_Gamma_Element

tempv = Vector{String}(["y1","u1","y2","u1","y3"])
tempq = Vector{String}(["x1","x2","x3"])
tempc = Vector{String}(["x1","x2"])

tempEXPxElt = EXP_X_Element((tempv,tempq,tempc))
newEXPGElt = EXP_Gamma_Element( tempEXPxElt )

@test tempEXPxElt.q == newEXPGElt.q
@test tempEXPxElt.c == newEXPGElt.c