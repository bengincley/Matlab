function [vector] = vectorize_dF(FS_area)
vector(1,length(FS_area)) = 0;
    for n=1:length(FS_area)
        vector(n) = FS_area(n).max_p1;
    end
end