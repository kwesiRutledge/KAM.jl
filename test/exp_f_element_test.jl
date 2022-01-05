#exp_f_element_test.jl
#Description:
#   Test the type and functions for EXP_F_Element.

using Test

include("../src/KAM.jl")

"""
Test 1: ChangeAllInstancesOfElement!
"""

# 1a: Change single element in list.

EXP_X_1a = Vector{EXP_X_Element}([
    EXP_X_Element( (["woah"],["typo"],["typo"]) ),
    EXP_X_Element( (["tvShow"],["walkingDead"],["walkingDead"]) ),
    EXP_X_Element( (["figure"],["it"],["out"]) )
])

EXP_F_1a = Vector{EXP_F_Element}([
    EXP_F_Element( ( EXP_X_1a[1] , "remote" , EXP_X_1a[2] ) ),
    EXP_F_Element( ( EXP_X_1a[2] , "class" , EXP_X_1a[3] ) ),
    EXP_F_Element( ( EXP_X_1a[3] , "do_homework" , EXP_X_1a[1] ) )
])

EXP_F_1a_copy = copy(EXP_F_1a)

target = EXP_X_Element( (EXP_X_1a[1].v, ["typo1"] , EXP_X_1a[1].c) )

ChangeAllInstancesOfElement!(EXP_F_1a_copy, EXP_X_1a[1] , target)

@test target == EXP_F_1a_copy[1].tuple1
@test target == EXP_F_1a_copy[3].tuple2
@test Set(EXP_F_1a) != Set(EXP_F_1a_copy)

# 4b: Change no elements in list.

exp_x_elt_1b = EXP_X_Element( (["woah"],["matrix"],["matrix"]) )
EXP_X_1b = Vector{EXP_X_Element}([
    EXP_X_Element( (["woah"],["typo"],["typo"]) ),
    EXP_X_Element( (["tvShow"],["walkingDead"],["walkingDead"]) ),
    EXP_X_Element( (["figure"],["it"],["out"]) )
])

EXP_F_1b = Vector{EXP_F_Element}([
    EXP_F_Element( ( EXP_X_1b[1] , "remote" , EXP_X_1b[2] ) ),
    EXP_F_Element( ( EXP_X_1b[2] , "class" , EXP_X_1b[3] ) ),
    EXP_F_Element( ( EXP_X_1b[3] , "do_homework" , EXP_X_1b[1] ) )
])

EXP_F_1b_copy = copy(EXP_F_1b)

target = EXP_X_Element( (EXP_X_1a[1].v, ["typo1"] , EXP_X_1a[1].c) )

ChangeAllInstancesOfElement!(EXP_F_1b_copy, exp_x_elt_1b , target)

@test target != EXP_F_1b_copy[1].tuple1
@test target != EXP_F_1b_copy[3].tuple2
@test Set(EXP_F_1b) == Set(EXP_F_1b_copy)