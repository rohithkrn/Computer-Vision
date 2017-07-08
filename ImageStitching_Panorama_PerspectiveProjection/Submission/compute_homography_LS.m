function H = compute_homography_LS(P1,P2)
 
N = size(P1,1);
% P1 = ones(N,3);
% P2 = ones(N,3);
% 
% P1(:,1:2) = m_fa(1:2,:)';
% P2(:,1:2) = m_fb(1:2,:)';

%% Homography - Least Squares

% P2 = H*P1

for i = 1:N
    A(2*i-1:2*i,:) = [-P1(i,1) -P1(i,2) -1 0 0 0 P1(i,1)*P2(i,1) P1(i,2)*P2(i,1);
         0 0 0 -P1(i,1) -P1(i,2) -1 P1(i,1)*P2(i,2) P1(i,2)*P2(i,2)];
    
    B(2*i-1:2*i) = [-P2(i,1) -P2(i,2)];
end

H1 = (A'*A)\(A'*B');
 H = ones(3,3);
 H(1,:) = H1(1:3);
 H(2,:) = H1(4:6);
 H(3,1:2) = H1(7:8);
 end
