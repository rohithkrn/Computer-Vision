function [X] = triangulate_2(P1,P2,p1,p2)

Sm1 = skew(p1');
Sm2 = skew(p2');

A = [Sm1*P1;Sm2*P2];

[U S V] =  svd(A);

X = V(:,end);
X = X/X(end);
X = X(1:3);
end