function [T1,T2,P_new1,P_new2] = MyRectify(P_old1,P_old2)

[A1,R1,t1] = art(P_old1);
[A2,R2,t2] = art(P_old2);

c1 = -inv(P_old1(:,1:3))*P_old1(:,4);
c2 = - inv(P_old2(:,1:3))*P_old2(:,4);

r1 = (c1-c2);
r2 = cross(R1(3,:)',r1);
r3 = cross(r1,r2);

R = [r1'/norm(r1)
r2'/norm(r2)
r3'/norm(r3)];

A = (A1 + A2)./2;
A(1,2)=0; 

P_new1 = A * [R -R*c1];
P_new2 = A * [R -R*c2];

T1 = P_new1(1:3,1:3)* inv(P_old1(1:3,1:3));
T2 = P_new2(1:3,1:3)* inv(P_old2(1:3,1:3));

end
