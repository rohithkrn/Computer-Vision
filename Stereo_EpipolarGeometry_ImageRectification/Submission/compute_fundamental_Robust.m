function [F_RS] = compute_fundamental_Robust(P1,P2,thresh)

tau = 0.95;
epsilon = 0.6;
nIter = log(1-tau)/log(1-(1-epsilon).^7);
% thresh = 0.001;
NoOfInliers = 0;
N = size(P1,1)

for i = 1:nIter
    ind = randperm(N,8);
    P1_rand = P1(ind,:);
    P2_rand = P2(ind,:);
    TempNoOfInliers = 0;
    TempMatchIndices = [];
    tempF = compute_findFundamentalMatrix(P1_rand,P2_rand);
    
    for j = 1:N
        err = P2(j,:)*tempF*P1(j,:)';
        if abs(err) < thresh
           TempNoOfInliers = TempNoOfInliers + 1;
           TempMatchIndices = [TempMatchIndices j];
        end       
    end
    
    if TempNoOfInliers > NoOfInliers
    MatchIndices = TempMatchIndices; 
    NoOfInliers = TempNoOfInliers;
    P1_inliers = P1(MatchIndices,:);
    P2_inliers = P2(MatchIndices,:);
    F_RS1 = compute_findFundamentalMatrix(P1_inliers,P2_inliers);
%     F_RS = tempF;
    end

end

TempNoOfInliers = 0;
TempMatchIndices = [];

for j = 1:N
        err = P2(j,:)*F_RS1*P1(j,:)';
        if abs(err) < thresh
           TempNoOfInliers = TempNoOfInliers + 1;
           TempMatchIndices = [TempMatchIndices j];
        end       
end
MatchIndices = TempMatchIndices; 
NoOfInliers_ref = TempNoOfInliers;
P1_inliers = P1(MatchIndices,:);
P2_inliers = P2(MatchIndices,:);
F_RS = compute_findFundamentalMatrix(P1_inliers,P2_inliers);


end