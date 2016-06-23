function [b_res_v,norm_rec_v] = vectorize_PP(PP_area)
b_res_v(1,5,length(PP_area)) = 0;
norm_rec_v(1,5,length(PP_area)) = 0;
    for n=1:length(PP_area)
        b_res_v(:,1:3,n) = PP_area(n).betas_residual;
        b_res_v(:,4:5,n) = PP_area(n).norm_recov(4:5);
        norm_rec_v(:,:,n) = PP_area(n).norm_recov;
    end
end