#exp_gamma_element.jl
#Description:
#   An element of the EXP_X_Gamma_Element.

const EXP_Gamma_Element = NamedTuple{
    (:q,:c),
    Tuple{Vector{String},Vector{String}}
    }

"""
EXP_Gamma_Element( elt::EXP_X_Element )
Description:
    Converts the EXP_X_Element elt into an EXP_Gamma_Element (projects onto the last two elements of the tuple).
"""
function EXP_Gamma_Element( elt::EXP_X_Element )
    return EXP_Gamma_Element( (elt.q,elt.c) )
end

"""
ChangeAllInstancesOfElement!( EXP_Gamma::Vector{EXP_Gamma_Element}, exp_gamma_elt_init::EXP_Gamma_Element , exp_gamma_elt_new::EXP_Gamma_Element  )
Description:
    Changes all instances of the element exp_gamma_elt_init in the set EXP_Gamma to be of value exp_gamma_elt_new.
"""
function ChangeAllInstancesOfElement!( EXP_Gamma::Vector{EXP_Gamma_Element}, exp_gamma_elt_init::EXP_Gamma_Element , exp_gamma_elt_new::EXP_Gamma_Element  )
    # Constants

    # Algorithm
    for exp_g_index in range(1,stop=length(EXP_Gamma))
        if EXP_Gamma[exp_g_index] == exp_gamma_elt_init
            EXP_Gamma[exp_g_index] = exp_gamma_elt_new
        end
    end

end