#exp_f_element.jl
#Description:
#   

const EXP_F_Element = NamedTuple{
    (:tuple1,:u,:tuple2),
    Tuple{EXP_X_Element,String,EXP_X_Element}
    }