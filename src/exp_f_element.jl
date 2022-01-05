#exp_f_element.jl
#Description:
#   

const EXP_F_Element = NamedTuple{
    (:tuple1,:u,:tuple2),
    Tuple{EXP_X_Element,String,EXP_X_Element}
    }


# Functions

"""
ChangeAllInstancesOfElement!( EXP_F::Vector{EXP_Gamma_Element}, exp_gamma_elt_init::EXP_Gamma_Element , exp_gamma_elt_new::EXP_Gamma_Element  )
Description:
    Changes all instances of the element exp_x_elt_init in the tuples of EXP_F to be of value exp_x_elt_new.
"""
function ChangeAllInstancesOfElement!( EXP_F::Vector{EXP_F_Element}, exp_x_elt_init::EXP_X_Element , exp_x_elt_new::EXP_X_Element  )
    # Constants

    # Algorithm
    for exp_f_index in range(1,stop=length(EXP_F))
        # For each tuple, check if exp_x_elt_init matches the first or second tuple
        if EXP_F[exp_f_index].tuple1 == exp_x_elt_init
            EXP_F[exp_f_index] = EXP_F_Element(
                ( exp_x_elt_new , EXP_F[exp_f_index].u , EXP_F[exp_f_index].tuple2 )
            )
        end

        if EXP_F[exp_f_index].tuple2 == exp_x_elt_init
            EXP_F[exp_f_index] = EXP_F_Element(
                ( EXP_F[exp_f_index].tuple1 , EXP_F[exp_f_index].u , exp_x_elt_new )
            )
        end
    end

end