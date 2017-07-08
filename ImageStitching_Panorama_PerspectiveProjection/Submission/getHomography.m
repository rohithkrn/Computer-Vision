function [H] = getHomography(P2,P1)
    
%% P1 = H*P2

%%
    % P = [u1,v1; u2, v2;...]
    for i = 1:size(P1,1)
    A(2*i-1:2*i,:) = [-P2(i,1) -P2(i,2) -1 0 0 0 P2(i,1)*P1(i,1) P2(i,2)*P1(i,1);
         0 0 0 -P2(i,1) -P2(i,2) -1 P2(i,1)*P1(i,2) P2(i,2)*P1(i,2)];
    
    B(2*i-1:2*i) = [-P1(i,1) -P1(i,2)];
    end  
    H1 = pinv(A)*B';
    H = ones(3,3);
    H(1,:) = H1(1:3);
    H(2,:) = H1(4:6);
    H(3,1:2) = H1(7:8);
    
end