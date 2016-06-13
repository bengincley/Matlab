function [dFoverF] = dF_Over_F_fun(base_F, pulse_data)
    base_dF = bsxfun(@minus, pulse_data, base_F);
    dFoverF = bsxfun(@rdivide, base_dF, base_F);