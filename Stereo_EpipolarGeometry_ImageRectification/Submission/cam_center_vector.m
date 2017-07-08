function [C,V] =  cam_center_vector(P,m)

Q = P(:,1:3);
q = P(:,4);
m_bar = m';
C = -Q\q;
V = Q\m_bar;

end