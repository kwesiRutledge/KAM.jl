"""
contribution.jl
Description:
    This file is meant to contain the core algorithms which define the contribution of the
    KAM paper.
"""

function KAM(system_in::System)
    # Constants

    # Algorithm
    cover = CreateCover(system_in)

    EXP_Gamma = Vector{EXP_Gamma_Element}([])
    EXP_X = GetInitialEXP_X(system_in,cover)
    EXP_F = Vector{EXP_F_Element}([])

    most_recent_EXP_X_elts = EXP_X

    while Set( ProjectToGammaSet(EXP_X) ) == Set(EXP_Gamma)
        # Project EXP_X to make new EXP_Gamma
        EXP_Gamma = ProjectToGammaSet(EXP_X)

        for exp_x_elt in most_recent_EXP_X_elts
            for u in system_in.U
                for y in system_in.Y
                    v_prime = push!(exp_x_elt.v,u,y)
                    c_prime::Vector{String} = intersect( F(exp_x_elt.c,u,system_in) , HInverse(y,system_in))
                    if length(c_prime) == 0
                        continue
                    end

                    Q_prime = GetMinimalCoverElementsContaining(c_prime,cover)

                    # Modify EXP_X and EXP_F
                    for q_prime in Q_prime
                        union!(EXP_X, EXP_X_Element( (v_prime,q_prime,c_prime) ) )
                        union!(EXP_F, EXP_F_Element( ( exp_x_elt , u , EXP_X_Element( (v_prime,q_prime,c_prime) ) ) ))
                    end

                end
            end

            # Determine if refinement is necessary
            # if exp_x_elt.c ⊊ exp_x_elt.q
            #     refine!( ( EXP_F , EXP_Gamma , EXP_X ) ,  )
            # end
        end
    end

end

"""
PostQ_u( exp_x_element_in::EXP_X_Element , u::String , EXP_F_in::Vector{EXP_F_Element} )
Description:
    For a given exp_x_element, this determines all possible states q which are known to follow exp_x_element
    according to the relation defined by EXP_F_in.
"""
function PostQ_u( exp_x_element_in::EXP_X_Element , u::String , EXP_F_in::Vector{EXP_F_Element} )
    # Constants
    #u_index = find_input_index_of(u)

    # Algorithm
    cover_subset = Vector{Vector{String}}([])
    for temp_exp_f_elt in EXP_F_in
        if (temp_exp_f_elt.tuple1 == exp_x_element_in) && (temp_exp_f_elt.u == u)
            # Append to cover_subset
            push!(cover_subset,temp_exp_f_elt.tuple2.q)
        end
    end

    # PostQ_u output created
    output = Vector{String}([])
    for cover_elt in cover_subset
        union!(output,cover_elt)
    end

    return output

end

"""
PostQ( exp_x_element_in::EXP_X_Element , system_in::System , EXP_F_in::Vector{EXP_F_Element} )
Description:
    For a given exp_x_element, this creates the vector of PostQ_u elements
    based on each input u from the system system_in.
"""
function PostQ( exp_x_element_in::EXP_X_Element , system_in::System , EXP_F_in::Vector{EXP_F_Element} )
    # Constants

    # Algorithm

    # PostQ output created by appending the output of PostQ_u for each input u
    output = Vector{Vector{String}}([])
    for u in system_in.U
        push!(output, PostQ_u( exp_x_element_in , u , EXP_F_in ) )
    end

    return output

end

"""
u_dependent_Pre()
Description:
    Computes a u-dependent version of the pre-operator based on the 
"""
function u_dependent_Pre( q::Vector{String}, system_in::System, PostQ::Vector{Vector{String}} )
    # constants

    # create s from special intersection.
    s = Vector{String}([])
    for temp_x in q # iterate through all elements in q
        x_valid_for_all_u = true # flag which determines if temp_x belongs in s
        for u_index in range(1,stop=length(system_in.U))
            
            # Determine if F(x,u) is a subset of PostQ_u (= PostQ[u_index])
            temp_Fxu = F(temp_x, system_in.U[u_index] , system_in)
            temp_PostQu = PostQ[u_index]

            # if something is the emptyset, then return false
            if (length(temp_Fxu) == 0) || (length(temp_PostQu) == 0)
                x_valid_for_all_u = false
                break
            end

            # Otherwise, do the set containment from line 27.
            if !( temp_Fxu ⊆ temp_PostQu )
                x_valid_for_all_u = false
                break
            end
            
        end

        # if all subset conditions are satisfied, then 
        if x_valid_for_all_u
            push!(s,temp_x)
        end
    end
    
    return s

end

# function PostQ_u( exp_x_element_in::EXP_X_Element , u_index::Integer , EXP_F_in::Vector{EXP_F_Element} )
#     # Constants

#     # Algorithm

    
# end

"""
refine()
Description:

    Lines 23 - 38 from Algorithm in 'On Abstraction Based Controller Design ... '
"""
function refine( exp_x_elt::EXP_X_Element , system_in::System, EXP_F_in::Vector{EXP_F_Element} , EXP_Gamma_in::Vector{EXP_Gamma_Element} , EXP_X_in::Vector{EXP_X_Element} )
    # Constants

    # Algorithm

    # Set default values for EXP_F_out, EXP_Gamma_out, EXP_X_out
    EXP_X_out = EXP_X_in
    EXP_Gamma_out = EXP_Gamma_in
    EXP_F_out = EXP_F_in

    PostQ_list = PostQ( exp_x_elt , system_in , EXP_F_in )
    s = u_dependent_Pre( exp_x_elt.q , system_in , PostQ_list )

end