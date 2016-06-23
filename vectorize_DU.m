function [vector] = vectorize_DU(DU_area)
vector(2,length(DU_area)) = 0;
    for n=1:length(DU_area)
        vector(:,n) = DU_area(n).sust_trans_ratio;
    end
end