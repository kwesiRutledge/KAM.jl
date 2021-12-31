#exp_gamma_element.jl
#Description:
#   An element of the EXP_X_Gamma_Element.

const EXP_Gamma_Element = NamedTuple{
    (:q,:c),
    Tuple{Vector{String},Vector{String}}
    }

"""

"""
function EXP_Gamma_Element( elt::EXP_X_Element )

    return EXP_Gamma_Element( (elt.q,elt.c) )

end