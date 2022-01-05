#extras.jl
#Description:
#

"""
set_to_vector
Description:
    Converts the string set to a vector.
"""
function set_to_vector(set_in::Set{String})
    # Constants

    # Algorithm
    vec_out = Vector{String}([])
    for elt in set_in
        # Append to vec
        push!(vec_out,elt)
    end

    return vec_out
end