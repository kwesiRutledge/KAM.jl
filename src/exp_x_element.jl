#exp_x_element.jl
#Description:
#   

const EXP_X_Element = NamedTuple{
    (:v,:q,:c),
    Tuple{Vector{String},Vector{String},Vector{String}}
    }

# Functions

"""
GetInitialEXP_X
Description:
    Creates the initial EXP_X set which has a simple external behavior sequence.
"""
function GetInitialEXP_X( system_in::System , cover_in::Vector{Vector{String}} )
    # Constants

    # Algorithm
    tempEXP_X = Vector{EXP_X_Element}([])
    for y_index = range(1,stop=length(cover_in))
        temp_y = system_in.Y[y_index]

        # Assemble tuples
        temp_q = cover_in[y_index]
        temp_c = intersect(system_in.X0,temp_q)

        # Push into Array
        if length(temp_c) > 0
            push!(tempEXP_X,EXP_X_Element( ( Vector{String}([temp_y]),temp_q,temp_c ) ) )
        end
    end

    return tempEXP_X
end

"""
ProjectToGammaSet
Description:
    Projects all of the elements in a set of EXP_X_Element elements to a set of 
"""
function ProjectToGammaSet( X_set::Vector{EXP_X_Element} )
    # Constants

    # Algorithm
    gamma_set_out = Vector{EXP_Gamma_Element}([])
    for x_elt in X_set
        # Append to the new Gamma Set each Projected element
        push!(gamma_set_out,EXP_Gamma_Element(x_elt))
    end

    return gamma_set_out
end