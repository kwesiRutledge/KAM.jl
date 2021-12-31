#exp_x_element.jl
#Description:
#   

const EXP_X_Element = NamedTuple{(:v,:q,:c)}

# Functions

"""
GetInitialEXP_X
Description:
    Creates the initial EXP_X set which has a simple external behavior sequence.
"""
function GetInitialEXP_X(system_in::System,cover_in::Vector{Vector{String}})
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
            push!(tempEXP_X,EXP_X_Element( ( Vector{String}([temp_y]),temp_q,convert(Vector{String},temp_c) ) ) )
        end
    end

    return tempEXP_X

end