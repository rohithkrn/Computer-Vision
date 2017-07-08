function [X] = triangulate_1(P1,P2,p1,p2)

[C1,V1] =  cam_center_vector(P1,p1);
[C2,V2] =  cam_center_vector(P2,p2);

T = C2 - C1;
V3 = skew(V1)*V2;

V = [V1 V2 V3];

abg = V\T;

X = C1 + abg(1)*V1 + 0.5*abg(3)*V3;

end