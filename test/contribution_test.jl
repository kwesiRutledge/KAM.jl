#contribution.jl
#Description:
#   Tests the algorithms in the contribution file.

using Test

include("../src/KAM.jl")

"""
Test 1: PostQ_u()
"""

# 1a: Test that This Works
EXP_X4a = Vector{EXP_X_Element}([
    EXP_X_Element( (["A"],["a1"],["a1"]) ),
    EXP_X_Element( (["A","u1","B"],["b1"],["b1"]) ),
    EXP_X_Element( (["A","u1","B","u1","C"],["c1"],["c1"]) ),
    EXP_X_Element( (["A","u1","B","u1","B"],["b2"],["b2"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","B"],["b1","b3"],["b1","b3"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","C"],["c2"],["c2"]) ),
    EXP_X_Element( (["A","u1","B","u1","C","u1","D"],["d1"],["d1"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","B","u1","B"],["b2","b4"],["b2","b4"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","B","u1","C"],["c1","c3"],["c1","c3"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","C","u1","D"],["d2"],["d2"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","D","u1","F"],["f1"],["f1"]) ),
    EXP_X_Element( (["A","u1","B","u1","B","u1","D","u1","G"],["g1"],["g1"]) )
])


exp_f1 = Vector{EXP_F_Element}([
    EXP_F_Element( (EXP_X4a[1],"u1",EXP_X4a[2]) ),
    EXP_F_Element( (EXP_X4a[2],"u1",EXP_X4a[3]) ),
    EXP_F_Element( (EXP_X4a[2],"u1",EXP_X4a[4]) ),
    EXP_F_Element( (EXP_X4a[3],"u1",EXP_X4a[7]) ),
    EXP_F_Element( (EXP_X4a[4],"u1",EXP_X4a[5]) ),
    EXP_F_Element( (EXP_X4a[4],"u1",EXP_X4a[6]) ),
    EXP_F_Element( (EXP_X4a[5],"u1",EXP_X4a[8]) ),
    EXP_F_Element( (EXP_X4a[5],"u1",EXP_X4a[9]) ),
    EXP_F_Element( (EXP_X4a[6],"u1",EXP_X4a[10]) ),
    EXP_F_Element( (EXP_X4a[7],"u1",EXP_X4a[11]) ),
    EXP_F_Element( (EXP_X4a[8],"u1",EXP_X4a[11]) )
])

q_subset = PostQ_u( EXP_X4a[1] , "u1" , exp_f1 )
# println(q_subset)

@test length(q_subset) == 1
@test q_subset == ["b1"]

# 1b: Tests for PostQ_u when there should be a set of two elements as output.

q_subset_1b = PostQ_u( EXP_X4a[2] , "u1" , exp_f1 )

@test length(q_subset_1b) == 2
@test Set(q_subset_1b) == Set(["b2","c1"])

# 1c: Tests when there are multiple inputs available

EXP_X1c = Vector{EXP_X_Element}([
    # t = 0
    EXP_X_Element( (["A"],["a1"],["a1"]) ),
    # t = 1
    EXP_X_Element( (["A","u1","B"],["b1"],["b1"]) ),
    EXP_X_Element( (["A","u2","B"],["b2"],["b2"]) ),
    # t = 2
    EXP_X_Element( (["A","u1","B","u1","C1"],["c1","c3"],["c1","c3"]) ),
    EXP_X_Element( (["A","u1","B","u2","C2"],["c2"],["c2"]) ),
    # t =  3
    EXP_X_Element( (["A","u1","B","u1","C1","u1","D1"],["d1"],["d1"]) ),
    EXP_X_Element( (["A","u1","B","u1","C1","u2","D2"],["d2"],["d2"]) ),
    EXP_X_Element( (["A","u1","B","u1","C1","u1","D3"],["d3"],["d3"]) ),
    EXP_X_Element( (["A","u1","B","u1","C1","u2","D4"],["d4"],["d4"]) ),
    EXP_X_Element( (["A","u1","B","u1","C2","u1","D2"],["d2"],["d2"]) ),
    EXP_X_Element( (["A","u1","B","u1","C2","u2","D3"],["d3"],["d3"]) )
])


EXP_F1c = Vector{EXP_F_Element}([
    EXP_F_Element( (EXP_X1c[1],"u1",EXP_X1c[2]) ),
    EXP_F_Element( (EXP_X1c[1],"u2",EXP_X1c[3]) ),
    EXP_F_Element( (EXP_X1c[2],"u1",EXP_X1c[4]) ),
    EXP_F_Element( (EXP_X1c[3],"u2",EXP_X1c[5]) ),
    EXP_F_Element( (EXP_X1c[4],"u1",EXP_X1c[6]) ),
    EXP_F_Element( (EXP_X1c[4],"u1",EXP_X1c[8]) ),
    EXP_F_Element( (EXP_X1c[4],"u2",EXP_X1c[7]) ),
    EXP_F_Element( (EXP_X1c[4],"u2",EXP_X1c[9]) ),
    EXP_F_Element( (EXP_X1c[5],"u1",EXP_X1c[10]) ),
    EXP_F_Element( (EXP_X1c[5],"u2",EXP_X1c[11]) )
])

output1c = PostQ_u( EXP_X1c[4] , "u1" , EXP_F1c )

@test length(output1c) == 2
@test Set(output1c) == Set(["d1","d3"])

"""
Test Set 2: u_dependent_Pre()
Description:
    Tests the u_dependent_Pre() function.
"""

# 2a: Single Input State in q, it satisfies PostQ_u 

system2a = get_vending_machine_system1()
q2a = Vector{String}(["pay"])
PostQ_2a = Vector{Vector{String}}([
    Vector{String}(["select"])
])

s_2a = u_dependent_Pre(q2a,system2a,PostQ_2a)

@test s_2a == q2a

# 2b: Single input State in q, it does NOT have a u_dependent Pre

system2b = get_vending_machine_system1()
q2b = Vector{String}(["get_beer"])
PostQ_2b = Vector{Vector{String}}([
    Vector{String}(["select"])
])

s_2b = u_dependent_Pre(q2b,system2b,PostQ_2b)

@test s_2b == []