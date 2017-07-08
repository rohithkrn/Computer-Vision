function [C R X max_ind] = Cheirality(C_cell, R_cell, X_cell)

for i = 1 : length(C_cell)
   Proj = R_cell{i}*(X_cell{i}-C_cell{i}*ones(1,size(X_cell{i},2)));
   n(i) = length(find(Proj(3,:)>0 & X_cell{i}(3,:)>0));
end

[max_n, max_ind] = max(n);
C = C_cell{max_ind};
R = R_cell{max_ind};
X = X_cell{max_ind};