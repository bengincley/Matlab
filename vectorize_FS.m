function [vector] = vectorize_FS(FS_area)
vector(2,5,length(FS_area)) = 0;
    for n=1:length(FS_area)
        vector(:,:,n) = FS_area(n).resp_v;
    end
end