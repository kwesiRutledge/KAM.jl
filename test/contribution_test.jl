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

"""
Test Set 3: refine
"""

# Test 3a: an instance where refinement is not necessary

sys_3a = get_vending_machine_system1()
cover_3a = CreateCover(sys_3a)

EXP_X_3a = Vector{EXP_X_Element}([
    EXP_X_Element((["pay"],["pay"],["pay"])),
    EXP_X_Element((["pay","N/A","select"],["select"],["select"])),
    EXP_X_Element((["pay","N/A","select","N/A","getting_drink"],["get_beer"],["get_beer"])),
    EXP_X_Element((["pay","N/A","select","N/A","getting_drink"],["get_soda"],["get_soda"]))
])

EXP_F_3a = Vector{EXP_F_Element}([
    EXP_F_Element( (EXP_X_3a[1],"N/A",EXP_X_3a[2]) ),
    EXP_F_Element( (EXP_X_3a[2],"N/A",EXP_X_3a[3]) ),
    EXP_F_Element( (EXP_X_3a[2],"N/A",EXP_X_3a[4]) )
])

target = EXP_X_3a[1]

EXP_F_3a_out , EXP_Gamma_3a_out , EXP_X_3a_out , cover_3a_out = refine(target, sys_3a, EXP_F_3a, ProjectToGammaSet(EXP_X_3a) , EXP_X_3a , cover_3a)

@test Set(EXP_F_3a_out) == Set(EXP_F_3a)
@test Set(ProjectToGammaSet(EXP_X_3a)) == Set(EXP_Gamma_3a_out)
@test Set(EXP_X_3a_out) == Set(EXP_X_3a)
@test Set(cover_3a_out) == Set(cover_3a)

# Test 3b: an instance where we know refinement (at least once) is necessary

# sys_3b = get_figure2_system(4)
# cover_3b = CreateCover(sys_3b)

# EXP_X_3b = Vector{EXP_X_Element}([
#     EXP_X_Element((["A"],["a1","a2"],["a1","a2"])),
#     EXP_X_Element((["A","N/A","A"],["a1","a2"],["a2"])),
#     EXP_X_Element((["A","N/A","B"],["b1","b2","b3","b4"],["b1"])),
#     EXP_X_Element((["A","N/A","A","N/A","A"],["a1","a2"],["a2"])),
#     EXP_X_Element((["A","N/A","B","N/A","A"],["a1","a2"],["a2"])),
#     EXP_X_Element((["A","N/A","B","N/A","B"],["b1","b2","b3","b4"],["b2"])),
#     # Fictitious element
#     EXP_X_Element((["A","N/A","B","N/A","B"],["b1","b2","b3","b4"],["b2"]))
# ]) #Sk

# EXP_F_3b = Vector{EXP_F_Element}([
#     EXP_F_Element( (EXP_X_3b[1],"N/A",EXP_X_3b[2]) ),
#     EXP_F_Element( (EXP_X_3b[1],"N/A",EXP_X_3b[3]) ),
#     EXP_F_Element( (EXP_X_3b[2],"N/A",EXP_X_3b[4]) ),
#     EXP_F_Element( (EXP_X_3b[3],"N/A",EXP_X_3b[5]) ),
#     EXP_F_Element( (EXP_X_3b[3],"N/A",EXP_X_3b[6]) ),
#     EXP_F_Element( (EXP_X_3b[3],"N/A",EXP_X_3b[7]) ),
# ])

# target = EXP_X_3b[3]

# EXP_F_3b_out , EXP_Gamma_3b_out , EXP_X_3b_out , cover_3b_out = refine(target, sys_3b, EXP_F_3b, ProjectToGammaSet(EXP_X_3b) , EXP_X_3b , cover_3b)

# # All Sets should be impacted
# println( Set(EXP_F_3b_out) == Set(EXP_F_3b) )
# @test Set(EXP_F_3b_out) != Set(EXP_F_3b)
# @test Set(ProjectToGammaSet(EXP_X_3b)) != Set(EXP_Gamma_3b_out)
# @test Set(EXP_X_3b_out) != Set(EXP_X_3b)
# @test Set(cover_3b_out) != Set(cover_3b)

# @test EXP_X_3b[3] != EXP_X_3b_out[3] #The second element should be updated.

# Test 3c: an instance where we know refinement (at least once) is necessary

sys_3c = get_figure3_system(1)
cover_3c = CreateCover(sys_3c)

EXP_X_3c = Vector{EXP_X_Element}([
    EXP_X_Element( ( ["A"] , ["a1"] , ["a1"] ) ),
    EXP_X_Element( ( ["A","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b2"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C","N/A","D"] , ["d1","d3^l","d3^r","d5^l","d5^r"] , ["d1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c2"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b1","b3"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C","N/A","D","N/A","F"] , ["f1","f2","f3","f4","f5","f6"] , ["f1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","C","N/A","E"] , ["e2^l","e2^r","e4","e6^l","e6^r"] , ["e2^l","e2^r"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c1","c3"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b2","b4"] ) )
    # False Elements
])

EXP_F_3c = Vector{EXP_F_Element}([
    EXP_F_Element( ( EXP_X_3c[1] , "N/A" , EXP_X_3c[2] ) ),
    EXP_F_Element( ( EXP_X_3c[2] , "N/A" , EXP_X_3c[3] ) ),
    EXP_F_Element( ( EXP_X_3c[2] , "N/A" , EXP_X_3c[4] ) ),
    EXP_F_Element( ( EXP_X_3c[3] , "N/A" , EXP_X_3c[5] ) ),
    EXP_F_Element( ( EXP_X_3c[4] , "N/A" , EXP_X_3c[6] ) ),
    EXP_F_Element( ( EXP_X_3c[4] , "N/A" , EXP_X_3c[7] ) ),
    EXP_F_Element( ( EXP_X_3c[5] , "N/A" , EXP_X_3c[8] ) ),
    EXP_F_Element( ( EXP_X_3c[6] , "N/A" , EXP_X_3c[9] ) ),
    EXP_F_Element( ( EXP_X_3c[7] , "N/A" , EXP_X_3c[10] ) ),
    EXP_F_Element( ( EXP_X_3c[7] , "N/A" , EXP_X_3c[11] ) )
])

target = EXP_X_3c[3] # This has unique successors within q

EXP_F_3c_out , EXP_Gamma_3c_out , EXP_X_3c_out , cover_3c_out = refine(target, sys_3c, EXP_F_3c, ProjectToGammaSet(EXP_X_3c) , EXP_X_3c , cover_3c)

# All Sets should be impacted
println( Set(EXP_F_3c_out) == Set(EXP_F_3c) )
@test Set(EXP_F_3c_out) != Set(EXP_F_3c)
@test Set(ProjectToGammaSet(EXP_X_3c)) != Set(EXP_Gamma_3c_out)
@test Set(EXP_X_3c_out) != Set(EXP_X_3c)
@test Set(cover_3c_out) != Set(cover_3c)

@test EXP_X_3c[3] != EXP_X_3c_out[3] #The second element should be updated.

# println(EXP_X_3c)
# println(EXP_X_3c_out)

"""
Test Set 4: extract
"""

# Test 4a: an instance where refinement is not necessary

sys_4a = get_vending_machine_system1()
cover_4a = CreateCover(sys_4a)

EXP_X_4a = Vector{EXP_X_Element}([
    EXP_X_Element((["pay"],["pay"],["pay"])),
    EXP_X_Element((["pay","N/A","select"],["select"],["select"])),
    EXP_X_Element((["pay","N/A","select","N/A","getting_drink"],["get_beer"],["get_beer"])),
    EXP_X_Element((["pay","N/A","select","N/A","getting_drink"],["get_soda"],["get_soda"]))
])

EXP_F_4a = Vector{EXP_F_Element}([
    EXP_F_Element( (EXP_X_4a[1],"N/A",EXP_X_4a[2]) ),
    EXP_F_Element( (EXP_X_4a[2],"N/A",EXP_X_4a[3]) ),
    EXP_F_Element( (EXP_X_4a[2],"N/A",EXP_X_4a[4]) )
])

sys_4a_out = extract( sys_4a , EXP_X_4a , EXP_F_4a )

@test length(sys_4a_out.X) == 4
@test length(sys_4a_out.U) == 1

# 4b: Test with figure 3 example

sys_4b = get_figure3_system(1)
cover_4b = CreateCover(sys_4b)

EXP_X_4b = Vector{EXP_X_Element}([
    EXP_X_Element( ( ["A"] , ["a1"] , ["a1"] ) ),
    EXP_X_Element( ( ["A","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b2"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C","N/A","D"] , ["d1","d3^l","d3^r","d5^l","d5^r"] , ["d1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c2"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b1","b3"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C","N/A","D","N/A","F"] , ["f1","f2","f3","f4","f5","f6"] , ["f1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","C","N/A","D","N/A","G"] , ["g1","g2","g3","g4","g5","g6"] , ["g1"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","C","N/A","E"] , ["e2^l","e2^r","e4","e6^l","e6^r"] , ["e2^l","e2^r"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B","N/A","C"] , ["c1","c2","c3","c4","c5","c6"] , ["c1","c3"] ) ),
    EXP_X_Element( ( ["A","N/A","B","N/A","B","N/A","B","N/A","B"] , ["b1","b2","b3","b4","b5","b6"] , ["b2","b4"] ) )
    # False Elements
])

EXP_F_4b = Vector{EXP_F_Element}([
    EXP_F_Element( ( EXP_X_4b[1] , "N/A" , EXP_X_4b[2] ) ),
    EXP_F_Element( ( EXP_X_4b[2] , "N/A" , EXP_X_4b[3] ) ),
    EXP_F_Element( ( EXP_X_4b[2] , "N/A" , EXP_X_4b[4] ) ),
    EXP_F_Element( ( EXP_X_4b[3] , "N/A" , EXP_X_4b[5] ) ),
    EXP_F_Element( ( EXP_X_4b[4] , "N/A" , EXP_X_4b[6] ) ),
    EXP_F_Element( ( EXP_X_4b[4] , "N/A" , EXP_X_4b[7] ) ),
    EXP_F_Element( ( EXP_X_4b[5] , "N/A" , EXP_X_4b[8] ) ),
    EXP_F_Element( ( EXP_X_4b[6] , "N/A" , EXP_X_4b[9] ) ),
    EXP_F_Element( ( EXP_X_4b[7] , "N/A" , EXP_X_4b[10] ) ),
    EXP_F_Element( ( EXP_X_4b[7] , "N/A" , EXP_X_4b[11] ) )
])

sys_4b_out = extract( sys_4b , EXP_X_4b , EXP_F_4b )

@test length(sys_4b_out.X) == 7
@test length(sys_4b_out.U) == 1

println(sys_4b_out.X)
println(sys_4b_out.X0)
println(sys_4b_out.HAsMatrix)