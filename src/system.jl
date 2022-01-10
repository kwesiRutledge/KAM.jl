# System
# Description:
#   A file containing some of the structures needed to represent and manipulate the
#   system object for use in the KAM algorithm.

using SparseArrays

# =======
# Objects
# =======

struct System
    X::Vector{String}
    X0::Vector{String}
    U::Vector{String}
    FAsMatrices::Vector{SparseMatrixCSC{Int,Int}}
    Y::Vector{String}
    HAsMatrix::SparseMatrixCSC{Int,Int}
end

# =========
# Functions
# =========

"""
System(n_X::Integer)
Description:
    An alternative function for defining a new system object.
    This implementation
"""
function System(n_X::Integer)
    # Constants

    # Algorithm
    tempX::Array{String} = []
    for x in range(1,stop=n_X)
        append!(tempX,[string("x",x)])
    end

    return System(tempX,[],[], Vector{SparseMatrixCSC{Int,Int}}([]), [],sparse([],[],[]) )
end

"""
System(n_X::Integer,n_U::Integer,n_Y::Integer)
"""
function System(n_X::Integer,n_U::Integer,n_Y::Integer)
    # Constants

    # Algorithm

    #x
    tempX::Vector{String} = []
    for x_index in range(1,stop=n_X)
        append!(tempX,[string("x",x_index)])
    end

    # Create n_U strings for U
    tempU::Vector{String} = []
    for u_index in range(1,stop=n_U)
        append!(tempU,[string("u_",u_index)])
    end

    #Create empty transition FAsMatrices
    tempFAsMatrices = Vector{SparseMatrixCSC{Int,Int}}([])
    for x_index in range(1,stop=n_X)
        push!(tempFAsMatrices,sparse([],[],[],n_U,n_X))
    end

    # Create n_Y strings for Y
    tempY::Vector{String} = []
    for y_index in range(1,stop=n_Y)
        append!(tempY,[string("y_",y_index)])
    end

    # Create empty output Matrix
    
    return System(tempX,[],tempU, tempFAsMatrices, tempY,sparse([],[],[],n_X,n_Y) )

end



"""
find_state_index_of(name_in::String, system_in::System)
Description:
    Retrieves the index of the state that has name name_in.
"""
function find_state_index_of(name_in::String, system_in::System)
    # Constants

    # algorithm
    for x_index = range(1, stop=length(system_in.X) )
        if system_in.X[x_index] == name_in
            return x_index
        end
    end

    # if the name was not found, then return -1.
    return -1

end

"""
find_input_index_of(name_in::String, system_in::System)
Description:
    Retrieves the index of the INPUT that has name name_in.
"""
function find_input_index_of(name_in::String, system_in::System)
    # Constants

    # algorithm
    for u_index = range(1, stop=length(system_in.U) )
        if system_in.U[u_index] == name_in
            return u_index
        end
    end

    # if the name was not found, then return -1.
    return -1

end

"""
find_output_index_of(name_in::String, system_in::System)
Description:
    Retrieves the index of the OUTPUT that has name name_in.
"""
function find_output_index_of(name_in::String, system_in::System)
    # Constants

    # algorithm
    for y_index = range(1, stop=length(system_in.Y) )
        if system_in.Y[y_index] == name_in
            return y_index
        end
    end

    # if the name was not found, then return -1.
    return -1

end

"""
F(x::String, u::String, system_in::System)
Description:
    Attempts to find the set of states that the system will transition to
    from the current state x with input u.
"""
function F(x::String, u::String, system_in::System)
    # Constants
    x_index = find_state_index_of(x,system_in)
    u_index = find_input_index_of(u,system_in)

    # Algorithm
    nextStateIndices = F(x_index,u_index,system_in) # See below for implementation of F for integers.

    nextStatesAsStrings = Array{String}([])
    for nsi_index = 1:length(nextStateIndices)
        push!(nextStatesAsStrings,system_in.X[nextStateIndices[nsi_index]])
    end

    return nextStatesAsStrings

end

"""
F(x_index::Integer, u_index::Integer, system_in::System)
Description:
    Attempts to find the set of states that the system will transition to
    from the current state system_in.X[x_index] with input system_in.U[u_index].
"""
function F(x_index::Integer, u_index::Integer, system_in::System)
    # Constants

    # Algorithm
    F_x = system_in.FAsMatrices[x_index]
    if F_x == []
        throw(DomainError("No transitions are defined for the system from the state "+string(x_index)+"."))
    end

    tempI, tempJ, tempV = findnz(F_x)
    matching_indices = findall( tempI .== u_index )

    return tempJ[ matching_indices ]

end

"""
F(x_array::Vector{String}, u::String, system_in::System)
Description:
    Attempts to find the set of states that the system will transition to
    from the current state x with input u.
"""
function F(x_array::Vector{String}, u::String, system_in::System)
    # Constants
    u_index = find_input_index_of(u,system_in)

    # Algorithm
    nextStateIndices = Vector{Integer}([])
    for x in x_array
        x_index = find_state_index_of(x,system_in)
        push!(nextStateIndices,F(x_index,u_index,system_in)...)
    end

    nextStatesAsStrings = Array{String}([])
    for nsi_index = 1:length(nextStateIndices)
        push!(nextStatesAsStrings,system_in.X[nextStateIndices[nsi_index]])
    end

    return nextStatesAsStrings

end

"""
F(x_indices::Vector{Integer}, u_index::Integer, system_in::System)
Description:
    Attempts to find the set of states that the system will transition to
    from the current state system_in.X[x_index] with input system_in.U[u_index].
"""
function F(x_indices::Vector{Integer}, u_index::Integer, system_in::System)
    # Constants

    # Algorithm
    ancestorStates = Vector{String}([])

    for x_index in x_indices
        push!(ancestorStates,F(x_index,u_index,system_in)...)
    end

    return ancestorStates

end



"""
H(x::String,system_in::System)
Description:
    When an input state is given, this function produces the output from the set of strings Y.
"""
function H(x::String,system_in::System)
    # Constants

    # Algorithm
    x_index = find_state_index_of(x,system_in)

    return system_in.Y[ H( x_index , system_in ) ]
end

"""
H(x_index::Integer,system_in::System)
Description:
    This function receives as input an index for the state of the system 
    (i.e. x_index such that X[x_index] is the state in question), and returns
    the index of the output that matches it.
"""
function H(x_index::Integer,system_in::System)
    # Constants

    # Algorithm
    tempXIndices, tempYIndices, tempV = findnz(system_in.HAsMatrix)
    matching_indices = findall( tempXIndices .== x_index )

    return tempYIndices[ matching_indices ]
end

function H(x_list::Vector{String},system_in::System)::Vector{String}
    # Constants

    # Algorithm
    y_list = H( x_list[1] , system_in )
    for x_index in range(2,stop=length(x_list))
        y_list = y_list ∩ H( x_list[x_index] , system_in) # ∩
    end

    return y_list
end


"""
HInverse(y::String,system_in::System)
Description:
    Returns the names of all states that have output y
"""
function HInverse(y::String,system_in::System)
    # Constants

    # Algorithm
    y_index = find_output_index_of(y,system_in)
    HInverse_as_indices = HInverse(y_index,system_in)

    matching_states = Array{String}([])
    for temp_index in HInverse_as_indices
        push!(matching_states,system_in.X[temp_index])
    end

    return matching_states

end

function HInverse(y_index::Integer,system_in::System)
    # Constants
    num_states = length(system_in.X)

    # Algorithm    
    tempXIndices, tempYIndices, tempV = findnz(system_in.HAsMatrix)
    matching_indices = findall( tempYIndices .== y_index )

    # Return matching states
    return tempXIndices[matching_indices]
end

"""
add_transition!(system_in::System,transition_in::Tuple{Int,Int,Int})
Description:
    Adds a transition to the system system_in according to the tuple of indices tuple_in.
        tuple_in = (x_in,u_in,x_next_in)
"""
function add_transition!(system_in::System,transition_in::Tuple{Int,Int,Int})
    # Constants
    x_in = transition_in[1]
    u_in = transition_in[2]
    x_next_in = transition_in[3]

    # Checking inputs
    check_x(x_in,system_in)
    check_u(u_in,system_in)
    check_x(x_next_in,system_in)
    
    # Algorithm
    system_in.FAsMatrices[x_in][u_in,x_next_in] = 1
    
end

"""
add_transition!(system_in::System,transition_in::Tuple{String,String,String})
Description:
    Adds a transition to the system system_in according to the tuple of names tuple_in.
        tuple_in = (x_in,u_in,x_next_in)
"""
function add_transition!(system_in::System,transition_in::Tuple{String,String,String})
    # Constants
    x_in = transition_in[1]
    u_in = transition_in[2]
    x_next_in = transition_in[3]

    # Checking inputs

    # println(transition_in)
    
    x_index = find_state_index_of(x_in,system_in)
    u_index = find_input_index_of(u_in,system_in)
    x_next_index = find_state_index_of(x_next_in,system_in)

    # Algorithm
    add_transition!(system_in,( x_index , u_index , x_next_index ))
    
end

"""
check_x(x_in::Integer,system_in::System)
Description:
    Checks to make sure that a possible state index is actually in the bounds of the s
"""
function check_x(x_in::Integer,system_in::System)
    # Constants
    n_X = length(system_in.X)

    # Algorithm
    if (1 > x_in) || (n_X < x_in)
        throw(DomainError("The input transition references a state " * string(x_in) * " which is not in the state space!"))
    end

    return
end

"""
check_x(x_in::String,system_in::System)
Description:
    Checks to make sure that a possible state index is actually in the bounds of the s
"""
function check_x(x_in::String,system_in::System)
    # Constants

    # Algorithm
    if !(x_in in system_in.X)
        throw(DomainError("The input transition references a state " * string(x_in) * " which is not in the state space!"))
    end

    return
end

"""
check_u(u_index_in::Integer,system_in::System)
Description:
    Checks to make sure that a possible state index is actually in the bounds of the s
"""
function check_u(u_index_in::Integer,system_in::System)
    # Constants
    n_U = length(system_in.U)

    # Algorithm
    if (1 > u_index_in) || (n_U < u_index_in)
        throw(DomainError("The input transition references a state " * string(u_index_in) * " which is not in the input space!"))
    end

    return
end

"""
check_u(u_in::String,system_in::System)
Description:
    Checks to make sure that a possible state index is actually in the bounds of the s
"""
function check_u(u_in::String,system_in::System)
    # Constants

    # Algorithm
    if !(u_in in system_in.U)
        throw(DomainError("The input transition references a state " * string(u_in) * " which is not in the input space!"))
    end

    return
end

"""
get_vending_machine_system()
Description:
    Returns the beverage vending machine example.
"""
function get_vending_machine_system1()
    # Constants
    state_names = ["pay","select","get_beer","get_soda"]
    input_names = ["N/A"]
    output_names = ["pay","select","getting_drink"]

    # Algorithm
    system_out = System(length(state_names),length(input_names),length(output_names))
    
    # Add state names
    for state_index in range(1,stop=length(state_names))
        system_out.X[state_index] = state_names[state_index]
    end

    # Add Input Names
    for input_index in range(1,stop=length(input_names))
        system_out.U[input_index] = input_names[input_index]
    end

    # Add Output Names
    for output_index in range(1,stop=length(output_names))
        system_out.Y[output_index] = output_names[output_index]
    end

    # Create transitions
    add_transition!(system_out,("pay","N/A","select"))
    add_transition!(system_out,("select","N/A","get_beer"))
    add_transition!(system_out,("select","N/A","get_soda"))
    add_transition!(system_out,("get_beer","N/A","pay"))
    add_transition!(system_out,("get_soda","N/A","pay"))

    # Create Outputs
    system_out.HAsMatrix[1,1] = 1
    system_out.HAsMatrix[2,2] = 1
    system_out.HAsMatrix[3,3] = 1
    system_out.HAsMatrix[4,3] = 1

    return system_out
end

"""
get_figure2_system(num_b::Integer)
Description:
    Returns the discrete state system example from Figure 2.
"""
function get_figure2_system(num_b::Integer)
    # Constants
    input_names = ["N/A"]
    output_names = ["A","B"]

    num_a = 2

    # Input Processing
    if num_b < 1
        throw(DomainError("The number of 'b' states must be a positive integer, not " * string(num_b) * "!"))
    end

    # Create System

    system_out = System(num_a+num_b,length(input_names),length(output_names))
    
    # Add state names
    system_out.X[1] = "a1"
    system_out.X[2] = "a2"
    for state_index in range(1,stop=num_b)
        system_out.X[state_index+2] = "b" * string(state_index)
    end

    # Add Input Names
    for input_index in range(1,stop=length(input_names))
        system_out.U[input_index] = input_names[input_index]
    end

    # Add Output Names
    for output_index in range(1,stop=length(output_names))
        system_out.Y[output_index] = output_names[output_index]
    end

    # Add Initial States
    push!(system_out.X0,"a1","a2")

    # Create transitions
    add_transition!(system_out,("a1","N/A","b1"))
    for b_index in range(2,stop=num_b)
        add_transition!(system_out,( "b" * string(b_index-1), "N/A" , "b" * string(b_index)  ))
        add_transition!(system_out,( "b" * string(b_index)  , "N/A" , "b" * string(b_index-1)  ))
        add_transition!(system_out,( "b" * string(b_index)  , "N/A" , "a2"  ))
    end

    add_transition!(system_out,("b1","N/A","a2"))
    add_transition!(system_out,("a2","N/A","a2"))

    # Create Outputs
    for x_index in range(1,stop=length(system_out.X))
        x = system_out.X[x_index]

        if (x == "a1") || (x == "a2")
            # Label with an A
            system_out.HAsMatrix[x_index,1] = 1
        else
            # Label with a B
            system_out.HAsMatrix[x_index,2] = 1
        end

    end

    return system_out
end

"""
get_figure3_system(num_patterns::Integer)
Description:
    Returns the discrete state system example from Figure 3 of the paper.
"""
function get_figure3_system(num_patterns::Integer)
    # Constants
    input_names = ["N/A"]
    output_names = ["A","B","C","D","E","F","G"]

    # Input Processing
    if num_patterns < 1
        throw(DomainError("The number of 'pattern repititions' states must be a positive integer, not " * string(num_patterns) * "!"))
    end

    # Create System
    n_a = 1
    n_b = 6 * num_patterns
    n_c = 6 * num_patterns
    n_d = ( 1 + 2 + 2 ) * num_patterns
    n_e = ( 1 + 2 + 2 ) * num_patterns
    n_f = 6 * num_patterns
    n_g = 6 * num_patterns

    n_list = [ n_a , n_b , n_c , n_d , n_e , n_f , n_g ]

    n_X = sum(n_list)

    system_out = System(n_X,length(input_names),length(output_names))
    
    # Add state names
    system_out.X[1] = "a1"
    temp_prefixes = ["a","b","c"]
    for prefix_index in range(1,stop=length(temp_prefixes))
        for state_index in range(1,stop=n_list[prefix_index])
            system_out.X[state_index+sum(n_list[1:prefix_index-1])] = temp_prefixes[prefix_index] * string(state_index)
        end
    end

    # insert d names
    for state_index in range(1,stop=n_d)
        if mod(state_index,5) == 1
            system_out.X[state_index+sum(n_list[1:3])] = "d" * string(state_index + div(state_index,5,RoundDown))
        elseif (mod(state_index,5) == 2)
            system_out.X[state_index+sum(n_list[1:3])] = "d" * string(state_index+1 + div(state_index,5,RoundDown)) * "^l"
        elseif mod(state_index,5) == 3
            system_out.X[state_index+sum(n_list[1:3])] = "d" * string(state_index + div(state_index,5,RoundDown)) * "^r"
        elseif mod(state_index,5) == 4
            system_out.X[state_index+sum(n_list[1:3])] = "d" * string(state_index+1 + div(state_index,5,RoundDown)) * "^l"
        elseif mod(state_index,5) == 0
            system_out.X[state_index+sum(n_list[1:3])] = "d" * string(state_index + div(state_index,5,RoundDown)-1) * "^r"
        end
    end

    # insert e names
    for state_index in range(1,stop=n_e)
        if mod(state_index,5) == 1
            system_out.X[state_index+sum(n_list[1:4])] = "e" * string(state_index+1 + div(state_index,5,RoundDown) ) * "^l"
        elseif (mod(state_index,5) == 2)
            system_out.X[state_index+sum(n_list[1:4])] = "e" * string(state_index + div(state_index,5,RoundDown) ) * "^r"
        elseif mod(state_index,5) == 3
            system_out.X[state_index+sum(n_list[1:4])] = "e" * string(state_index+1 + div(state_index,5,RoundDown) )
        elseif mod(state_index,5) == 4
            system_out.X[state_index+sum(n_list[1:4])] = "e" * string(state_index+2 + div(state_index,5,RoundDown) ) * "^l"
        elseif mod(state_index,5) == 0
            system_out.X[state_index+sum(n_list[1:4])] = "e" * string(state_index+1 + div(state_index,5,RoundDown)-1 ) * "^r"
        end
    end

    # insert f and g names
    temp_prefixes2 = ["f","g"]
    for prefix_index in range(1,stop=length(temp_prefixes2))
        for state_index in range(1,stop=n_list[5+prefix_index])
            system_out.X[state_index+sum(n_list[1:5+prefix_index-1])] = temp_prefixes2[prefix_index] * string(state_index)
        end
    end

    # for state_index in range(1,stop=length(system_out.X))
    #     println(system_out.X[state_index])
    # end

    # Add Input Names
    for input_index in range(1,stop=length(input_names))
        system_out.U[input_index] = input_names[input_index]
    end

    # Add Output Names
    for output_index in range(1,stop=length(output_names))
        system_out.Y[output_index] = output_names[output_index]
    end

    # Add Initial States
    push!(system_out.X0,"a1")

    # Create transitions
    add_transition!(system_out,("a1","N/A","b1"))
    # Add b transitions
    for b_index in range(1,stop=n_b-1)
        add_transition!(system_out,( "b" * string(b_index+1), "N/A" , "b" * string(b_index)  ))
        add_transition!(system_out,( "b" * string(b_index)  , "N/A" , "b" * string(b_index+1)  ))
        add_transition!(system_out,( "b" * string(b_index)  , "N/A" , "c" * string(b_index)  ))
    end
    # Add c transitions
    for c_index in range(1,stop=n_c)
        if mod(c_index,6) == 1
            # Send to the a state marked d * string(c_index)
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "d" * string(c_index)  ))
        elseif mod(c_index,6) == 2
            # Send to the left and right e states
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "e" * string(c_index) * "^l" ))
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "e" * string(c_index) * "^r" ))
        elseif mod(c_index,6) == 3
            # Send to the left and right d states
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "d" * string(c_index) * "^l" ))
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "d" * string(c_index) * "^r" ))
        elseif mod(c_index,6) == 4
            # Send to the a state marked e * string(c_index)
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "e" * string(c_index)  ))
        elseif mod(c_index,6) == 5
            # Send to the left and right d states
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "d" * string(c_index) * "^l" ))
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "d" * string(c_index) * "^r" ))
        elseif mod(c_index,6) == 0
            # Send to the left and right e states
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "e" * string(c_index) * "^l" ))
            add_transition!(system_out,( "c" * string(c_index)  , "N/A" , "e" * string(c_index) * "^r" ))
        end
    end

    # add d transitions
    for d_index in range(1,stop=n_d)
        if mod(d_index,5) == 1
            # Send to both f and g states with d_index
            add_transition!(system_out,( "d" * string(d_index + div(d_index,5,RoundDown) )  , "N/A" , "f" * string(d_index + div(d_index,5,RoundDown))  ))
            add_transition!(system_out,( "d" * string(d_index + div(d_index,5,RoundDown) )  , "N/A" , "g" * string(d_index + div(d_index,5,RoundDown))  ))
        elseif mod(d_index,5) == 2
            # This is the left state. Send to the f state
            add_transition!(system_out,( "d" * string(d_index+1 + div(d_index,5,RoundDown) ) * "^l"  , "N/A" , "f" * string(d_index+1 + div(d_index,5,RoundDown) ) ))
        elseif mod(d_index,5) == 3
            # This is the right state. Send to the g state with d_index
            add_transition!(system_out,( "d" * string(d_index + div(d_index,5,RoundDown)) * "^r"  , "N/A" , "g" * string(d_index + div(d_index,5,RoundDown)) ))
        elseif mod(d_index,5) == 4
            # This is the left state. Send to the f state
            add_transition!(system_out,( "d" * string(d_index+1 + div(d_index,5,RoundDown) ) * "^l"  , "N/A" , "f" * string(d_index+1 + div(d_index,5,RoundDown) )) )
        elseif mod(d_index,5) == 0
            # This is the right state. Send to the g state with d_index
            add_transition!(system_out,( "d" * string(d_index + div(d_index,5,RoundDown) - 1 ) * "^r"  , "N/A" , "g" * string(d_index + div(d_index,5,RoundDown) -1 ) ))
        end
    end

    # add e transitions
    for e_index in range(1,stop=n_e)
        if mod(e_index,5) == 1
            # This is the left state. Route to f
            add_transition!(system_out,( "e" * string(e_index+1 + div(e_index,5,RoundDown) ) * "^l"  , "N/A" , "f" * string(e_index+1 + div(e_index,5,RoundDown) ) ))
        elseif mod(e_index,5) == 2
            # This is the right state. Send to the g state with e_index
            add_transition!(system_out,( "e" * string(e_index + div(e_index,5,RoundDown) ) * "^r"  , "N/A" , "g" * string(e_index + div(e_index,5,RoundDown) ) ))
        elseif mod(e_index,5) == 3
            # Send to both f and g states with e_index
            add_transition!(system_out,( "e" * string(e_index+1 + div(e_index,5,RoundDown) )  , "N/A" , "f" * string(e_index+1 + div(e_index,5,RoundDown) )  ))
            add_transition!(system_out,( "e" * string(e_index+1 + div(e_index,5,RoundDown) )  , "N/A" , "g" * string(e_index+1 + div(e_index,5,RoundDown) )  ))
        elseif mod(e_index,5) == 4
            # This is the left state. Send to the f state
            add_transition!(system_out,( "e" * string(e_index+2 + div(e_index,5,RoundDown)) * "^l"  , "N/A" , "f" * string(e_index+2 + div(e_index,5,RoundDown) ) ))
        elseif mod(e_index,5) == 0
            # This is the right state. Send to the g state with e_index
            add_transition!(system_out,( "e" * string(e_index+1 + div(e_index,5,RoundDown) - 1) * "^r"  , "N/A" , "g" * string(e_index+1 + div(e_index,5,RoundDown) - 1 ) ))
        end

    end

    # add f and g transitions
    for state_index in range(1,stop=n_f)
        add_transition!(system_out,( "f" * string(state_index) , "N/A" , "f" * string(state_index) ))
        add_transition!(system_out,( "g" * string(state_index) , "N/A" , "g" * string(state_index) ))
    end

    # add_transition!(system_out,("b1","N/A","a2"))
    # add_transition!(system_out,("a2","N/A","a2"))

    # Create Outputs
    temp_prefixes3 = ["a","b","c","d","e","f","g"]
    for x_index in range(1,stop=length(system_out.X))
        x = system_out.X[x_index]

        # Search for matches in temp_prefixes3
        for prefix_index in range(1,stop=length(temp_prefixes3))
            if contains( x , temp_prefixes3[prefix_index] )
                system_out.HAsMatrix[x_index,prefix_index] = 1
            end

        end

    end

    return system_out
end