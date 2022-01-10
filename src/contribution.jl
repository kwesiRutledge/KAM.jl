"""
contribution.jl
Description:
    This file is meant to contain the core algorithms which define the contribution of the
    KAM paper.
"""

function KAM(system_in::System, max_iter::Integer)::System
    # Constants

    # Algorithm
    cover = CreateCover(system_in)

    EXP_Gamma = Vector{EXP_Gamma_Element}([])
    EXP_X = GetInitialEXP_X(system_in,cover)
    EXP_F = Vector{EXP_F_Element}([])

    num_iterations::Integer = 0
    most_recent_EXP_X_elts = EXP_X

    S_hat = system_in

    while Set( ProjectToGammaSet(EXP_X) ) != Set(EXP_Gamma)

        # Project EXP_X to make new EXP_Gamma
        EXP_Gamma = ProjectToGammaSet(EXP_X)

        # Save old Sets for later use
        EXP_F_previous = copy(EXP_F)
        EXP_Gamma_previous = copy(EXP_Gamma)
        EXP_X_previous = copy(EXP_X)
        cover_previous = copy(cover)

        # Get most recent EXP_X_Element Objects
        most_recent_EXP_X_elts = Vector{EXP_X_Element}([])
        for elt in EXP_X
            if length(elt.v) == 2*num_iterations + 1
                push!(most_recent_EXP_X_elts,elt)
            end
        end

        # println(most_recent_EXP_X_elts)
        new_EXP_X_elts = Vector{EXP_X_Element}([])

        for exp_x_elt in most_recent_EXP_X_elts
            for u in system_in.U
                for y in system_in.Y

                    v_prime = push!(copy(exp_x_elt.v),u,y)
                    c_prime::Vector{String} = intersect( F(exp_x_elt.c,u,system_in) , HInverse(y,system_in))
                    if length(c_prime) == 0
                        continue
                    end

                    Q_prime = GetMinimalCoverElementsContaining(c_prime,cover)
                    
                    # Modify EXP_X and EXP_F
                    for q_prime in Q_prime
                        union!(new_EXP_X_elts, [ EXP_X_Element( (v_prime, q_prime, c_prime) ) ] )
                        union!(EXP_F, [ EXP_F_Element( ( exp_x_elt , u , EXP_X_Element( (v_prime,q_prime,c_prime) ) ) ) ] )
                    end

                end
            end

            union!( EXP_X , new_EXP_X_elts )

            # Determine if refinement is necessary
            if exp_x_elt.c ⊊ exp_x_elt.q
                EXP_F , EXP_Gamma , EXP_X , cover = refine( exp_x_elt, system_in, EXP_F, EXP_Gamma , EXP_X , cover)
            end

        end

        # Extract System
        
        # println("EXP_X")
        # println(EXP_X)
        # println("EXP_F")
        # println(EXP_F)

        # println(EXP_X)

        S_hat = extract(system_in , EXP_X , EXP_F )

        # Update Number of Iterations
        num_iterations += 1

        # Termination conditions
        if num_iterations == max_iter
            # If the algorithm has exceeded the maximum number of iterations,
            # then return.
            break
        end

        
        
    end

    return S_hat

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
function refine( exp_x_elt::EXP_X_Element , system_in::System, EXP_F_in::Vector{EXP_F_Element} , EXP_Gamma_in::Vector{EXP_Gamma_Element} , EXP_X_in::Vector{EXP_X_Element} , Cover_in::Vector{Vector{String}} )
    # Constants

    # Algorithm

    # Set default values for EXP_F_out, EXP_Gamma_out, EXP_X_out
    EXP_X_out = copy(EXP_X_in)
    EXP_Gamma_out = copy(EXP_Gamma_in)
    EXP_F_out = copy(EXP_F_in)
    Cover_out = copy(Cover_in)

    PostQ_list = PostQ( exp_x_elt , system_in , EXP_F_in )
    s = u_dependent_Pre( exp_x_elt.q , system_in , PostQ_list )

    if length(s) == 0
        # if s is the empty set, then refine nothing.
        return EXP_F_out , EXP_Gamma_out , EXP_X_out , Cover_out
    end

    if s ⊊ exp_x_elt.q
        # If the set s is smaller than q, then we can refine our sets.
        push!(Cover_out,s) #Add s to the cover

        # Modify EXP_Gamma, EXP_F, EXP_X
        for temp_exp_x_elt in EXP_X_out
            
            if (temp_exp_x_elt.c ⊊ s) && (temp_exp_x_elt.q == exp_x_elt.q) # TODO: Find out if this should be strict subset ⊊ or just subset ⊆
                ChangeAllInstancesOfElement!(EXP_X_out, temp_exp_x_elt , EXP_X_Element( (temp_exp_x_elt.v, s , temp_exp_x_elt.c) ) )
                ChangeAllInstancesOfElement!(EXP_Gamma_out, EXP_Gamma_Element( temp_exp_x_elt ) , EXP_Gamma_Element( ( s , temp_exp_x_elt.c) ) )
                ChangeAllInstancesOfElement!(EXP_F_out, temp_exp_x_elt , EXP_X_Element( (temp_exp_x_elt.v, s , temp_exp_x_elt.c) ) )
            end
        end

        #Check to see if more refinement is necessary.
        for temp_exp_f_elt in EXP_F_out
            if ( Set(temp_exp_f_elt.tuple2.q) == Set(s) ) && ( temp_exp_f_elt.tuple1.c ⊊ temp_exp_f_elt.tuple1.q )
                EXP_F_out, EXP_Gamma_out, EXP_X_out, Cover_out = refine( temp_exp_f_elt.tuple1 , system_in , EXP_F_out , EXP_Gamma_out , EXP_X_out , Cover_out )
            end
        end
    end

    # Return new sets
    return EXP_F_out , EXP_Gamma_out , EXP_X_out , Cover_out

end

"""
extract(EXP_X::Vector{EXP_X_Element},EXP_F::Vector{EXP_F_Element})::System
Description:
    Converts an EXP_X and EXP_F representation into a new system.
"""
function extract(system_in::System,EXP_X::Vector{EXP_X_Element},EXP_F::Vector{EXP_F_Element})::System
    # Constants

    # Algorithm
    Xhat = Vector{Vector{String}}([])
    for exp_x_elt in EXP_X
        if !(exp_x_elt.q in Xhat)
            push!(Xhat,exp_x_elt.q)
        end
    end

    Xhat0 = Vector{Vector{String}}([])
    for y in system_in.Y
        xhat0_candidate::Vector{String} = HInverse(y,system_in) ∩ system_in.X0 
        if length(xhat0_candidate) > 0
            push!(Xhat0,xhat0_candidate)
        end
    end

    # Create blank transition System
    sys_out = System( length(Xhat) , length(system_in.U) , length(system_in.Y) )

    # Add state names
    for xhat_index in range(1,stop=length(Xhat))
        xhat = Xhat[xhat_index]

        # Create names for each element.
        xhat_name = ""
        for elt_index in range(1,stop=length(xhat))
            temp_elt = xhat[elt_index]
            xhat_name *= string(temp_elt)
            if elt_index != length(xhat)
                xhat_name *= ","
            end
        end
        # Add name
        sys_out.X[xhat_index] = xhat_name
    end

    # Define the Xhat0 names.
    for xhat_index in range(1,stop=length(Xhat0))
        xhat = Xhat[xhat_index]

        # Create names for each element.
        xhat_name = ""
        for elt_index in range(1,stop=length(xhat))
            temp_elt = xhat[elt_index]
            xhat_name *= string(temp_elt)
            if elt_index != length(xhat)
                xhat_name *= ","
            end
        end
        # Add name
        push!(sys_out.X0,xhat_name)
    end

    # Define the Outputs
    for xhat_index in range(1,stop=length(Xhat))
        xhat = Xhat[xhat_index]
        for yhat_index in range(1,stop=length(system_in.Y))
            if system_in.Y[yhat_index] in H(xhat,system_in)
                sys_out.HAsMatrix[xhat_index,yhat_index] = 1
            end
        end
    end

    return sys_out

end