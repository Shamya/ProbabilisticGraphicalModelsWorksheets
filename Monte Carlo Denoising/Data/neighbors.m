function [N, nb] = neighbors( i, j )
%calculate the number of neighbors and their indices
N = 0;
nb=[];
idx = zeros(1,2);

%check if these actions are valid
if i-1>0
    N = N + 1;
    idx = [i-1,j];
    nb = [nb; idx];
end
if i+1<51
    N = N + 1;
    idx = [i+1,j];
    nb = [nb; idx];
end
if j-1>0
    N = N + 1;
    idx = [i,j-1];
    nb = [nb; idx];
end
if j+1<51
    N = N + 1;
    idx = [i,j+1];
    nb = [nb; idx];
end
end

