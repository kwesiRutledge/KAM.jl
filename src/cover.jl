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

"""
GetMinimalCoverElementsContaining
Description:
    This function atttempts to find the elements in the set cover_in
    that contain the input q_prime but are also minimal with respect to other elements in the
    cover.
"""
function GetMinimalCoverElementsContaining(q_prime::Vector{String},cover_in::Vector{Vector{String}})
    # Constants

    # Algorithm

    # Collect all cover elements that contain q_prime
    cover_elts_containing_q_prime = Vector{Vector{String}}([])
    for cover_elt in cover_in
        if q_prime ⊆ cover_elt
            push!(cover_elts_containing_q_prime,cover_elt)
        end
    end

    # Identify if q_prime is minimal.
    minimalElts = Vector{Vector{String}}([])
    for cover_elt in cover_elts_containing_q_prime
        if IsMinimalCoverElement(cover_elt,cover_in)
            push!(minimalElts,cover_elt)
        end
    end

    return minimalElts

end

"""
IsMinimalCoverElement(c_prime::Vector{String},cover_in::Vector{Vector{String}})
Description:
    Determines if the cover element given as input (c_prime) is also a MINIMAL element in the set
    cover_in.
"""
function IsMinimalCoverElement(c_prime::Vector{String},cover_in::Vector{Vector{String}})
    # Constants

    # Algorithm
    if !( c_prime in cover_in )
        throw(DomainError("The input element c_prime is not in the cover set cover_in!"))
    end

    for c_double_prime in cover_in
        # Only compare elements that aren't the same
        if Set(c_prime) == Set(c_double_prime)
            continue
        end
        
        # If there exists an element which is a STRICT SUBSET of c_prime,
        # then c_prime is not minimal
        if Set(c_double_prime) ⊊ Set(c_prime)
            println("c_double_prime")
            println(c_double_prime)
            println(c_prime)
            return false
        end
    end

    # Otherwise, c_prime is minimal
    return true
end