#cover.jl
#Description:
#    Some functions related to the concept of the 'cover' in the KAM paper.


"""
CreateCover
Description:
    Creates a cover. The cover specified in the paper is a set of subsets of system_in.X.
    Each element of the cover q (which is a subset) is defined as the subset of states which share
    an output.
"""
function CreateCover(system_in::System)
    # Constants

    # Algorithm
    tempCover = Vector{Vector{String}}([])
    for y_index = range(1,stop=length(system_in.Y))
        # For each output, find the set of states that has it.
        push!(tempCover,HInverse( system_in.Y[y_index],system_in))
    end

    return tempCover
end