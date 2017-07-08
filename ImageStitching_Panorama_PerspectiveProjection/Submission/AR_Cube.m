function [IM_AR, Cam_R, Cam_t] = AR_Cube(IM, Ang, t)

IM = imrotate(IM,270);
figure,imshow(IM); hold on;
[x,y] = getpts;

paper_width = 8.5;
paper_height = 11;
% P1 - pixel coordinates
P1 = [x(1) y(1) 1; x(2) y(2) 1; x(3) y(3) 1; x(4) y(4) 1];
%P2 - World Coordinates
P2 = [0 0 1; 0 paper_width 1; paper_height paper_width 1;paper_height 0 1]; 

H = getHomography(P2,P1);

%% Intrinsic matrix
[s1, s2,~] =  size(IM);
f = max(s1,s2)/2;
px = size(IM,2)/2;
py = size(IM,1)/2;

K = [f 0 px;
     0 f py;
     0 0 1];
 
%%

Pc = pinv(K)*H;
R1 = Pc(:,1);
R2 = Pc(:,2);
Cam_t = Pc(:,3);

if t(3) < 0
    R1 = -R1; R2 = -R2; Cam_t = -Cam_t;
end

R3 = skew(R2)*R1;
P = [R1, R2, R3, Cam_t];

Cam_R = P(:,1:3)
Cam_t = P(:,4)

% Ang = 45;
% t = [8 5 0];

Tran_Mat = [cosd(Ang) -sind(Ang) 0 t(1);
            sind(Ang) cosd(Ang) 0 t(2)
             0          0       1 t(3)
             0          0       0  1  ];

% Cube World Coordinates
len = 2; width = 2; height = 12;

world_cord1 = [0;0;0;1];
world_cord2 = [0;width;0;1];
world_cord3 = [len;width;0;1];
world_cord4 = [len;0;0;1];
world_cord5 = [0;0;height;1];
world_cord6 = [0;width;height;1];
world_cord7 = [len;width;height;1];
world_cord8 = [len;0;height;1];
world_cord = [world_cord1,world_cord2,world_cord3,world_cord4,world_cord5,world_cord6,world_cord7,world_cord8];
world_cord = Tran_Mat*world_cord;

world_cord_cam = P*world_cord;

C_proj = K*world_cord_cam;

for i=1:8
    C_proj(:,i)=C_proj(:,i)/C_proj(3,i);
end

figure; imshow(IM); hold on; title 'Cube on the paper displaying all the faces'
plot(C_proj(1,:),C_proj(2,:),'rx');

% faces
  fill_lev = fill([C_proj(1,1) C_proj(1,4) C_proj(1,8) C_proj(1,5)],[C_proj(2,1) C_proj(2,4) C_proj(2,8) C_proj(2,5)],'r');
  set(fill_lev,'FaceAlpha',0.7); hold on
  fill_lev = fill([C_proj(1,2) C_proj(1,3) C_proj(1,7) C_proj(1,6)],[C_proj(2,2) C_proj(2,3) C_proj(2,7) C_proj(2,6)],'b');
  set(fill_lev,'FaceAlpha',0.7); hold on
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,6) C_proj(1,5)],[C_proj(2,1) C_proj(2,2) C_proj(2,6) C_proj(2,5)],'g');
  set(fill_lev,'FaceAlpha',0.7); hold on
  fill_lev = fill([C_proj(1,3) C_proj(1,4) C_proj(1,8) C_proj(1,7)],[C_proj(2,3) C_proj(2,4) C_proj(2,8) C_proj(2,7)],'c');
  set(fill_lev,'FaceAlpha',0.7); hold on
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,3) C_proj(1,4)],[C_proj(2,1) C_proj(2,2) C_proj(2,3) C_proj(2,4)],'m');
  set(fill_lev,'FaceAlpha',0.7); hold on
  fill_lev = fill([C_proj(1,5) C_proj(1,6) C_proj(1,7) C_proj(1,8)],[C_proj(2,5) C_proj(2,6) C_proj(2,7) C_proj(2,8)],'y');

  
  %% Computing the visible faces
figure; imshow(IM); hold on; title 'Cube on the paper displaying visible faces'
plot(C_proj(1,:),C_proj(2,:),'rx');

%face1

edge1_f1 = world_cord1(1:3) - world_cord5(1:3);
edge2_f1 = world_cord1(1:3) - world_cord4(1:3);

norm_f1 = cross(edge1_f1,edge2_f1);

vec1_f1 = Cam_t - world_cord1(1:3);
vec2_f1 = world_cord2(1:3) - world_cord1(1:3);

sign1 = sign(vec1_f1'*norm_f1);
sign2 = sign(vec2_f1'*norm_f1);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,1) C_proj(1,4) C_proj(1,8) C_proj(1,5)],[C_proj(2,1) C_proj(2,4) C_proj(2,8) C_proj(2,5)],'r');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else  
  fill_lev = fill([C_proj(1,1) C_proj(1,4) C_proj(1,8) C_proj(1,5)],[C_proj(2,1) C_proj(2,4) C_proj(2,8) C_proj(2,5)],'r');
  set(fill_lev,'FaceAlpha',0.2); hold on  
end

%face2

edge1_f = world_cord1(1:3) - world_cord2(1:3);
edge2_f = world_cord1(1:3) - world_cord5(1:3);

norm_f = cross(edge1_f,edge2_f);

vec1_f = Cam_t - world_cord1(1:3);
vec2_f = world_cord4(1:3) - world_cord1(1:3);

sign1 = sign(vec1_f'*norm_f);
sign2 = sign(vec2_f'*norm_f);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,6) C_proj(1,5)],[C_proj(2,1) C_proj(2,2) C_proj(2,6) C_proj(2,5)],'g');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,6) C_proj(1,5)],[C_proj(2,1) C_proj(2,2) C_proj(2,6) C_proj(2,5)],'g');
  set(fill_lev,'FaceAlpha',0.2); hold on  
end

%face3

edge1_f = world_cord2(1:3) - world_cord3(1:3);
edge2_f = world_cord3(1:3) - world_cord7(1:3);

norm_f = cross(edge1_f,edge2_f);

vec1_f = Cam_t - world_cord2(1:3);
vec2_f = world_cord1(1:3) - world_cord2(1:3);

sign1 = sign(vec1_f'*norm_f);
sign2 = sign(vec2_f'*norm_f);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,2) C_proj(1,3) C_proj(1,7) C_proj(1,6)],[C_proj(2,2) C_proj(2,3) C_proj(2,7) C_proj(2,6)],'b');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else
  fill_lev = fill([C_proj(1,2) C_proj(1,3) C_proj(1,7) C_proj(1,6)],[C_proj(2,2) C_proj(2,3) C_proj(2,7) C_proj(2,6)],'b');
  set(fill_lev,'FaceAlpha',0.2); hold on  
end
%face4

edge1_f = world_cord3(1:3) - world_cord4(1:3);
edge2_f = world_cord4(1:3) - world_cord8(1:3);

norm_f = cross(edge1_f,edge2_f);

vec1_f = Cam_t - world_cord3(1:3);
vec2_f = world_cord1(1:3) - world_cord4(1:3);

sign1 = sign(vec1_f'*norm_f);
sign2 = sign(vec2_f'*norm_f);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,3) C_proj(1,4) C_proj(1,8) C_proj(1,7)],[C_proj(2,3) C_proj(2,4) C_proj(2,8) C_proj(2,7)],'c');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else
  fill_lev = fill([C_proj(1,3) C_proj(1,4) C_proj(1,8) C_proj(1,7)],[C_proj(2,3) C_proj(2,4) C_proj(2,8) C_proj(2,7)],'c');
  set(fill_lev,'FaceAlpha',0.2); hold on  
end

%face5

edge1_f = world_cord5(1:3) - world_cord6(1:3);
edge2_f = world_cord6(1:3) - world_cord7(1:3);

norm_f = cross(edge1_f,edge2_f);

vec1_f = Cam_t - world_cord5(1:3);
vec2_f = world_cord1(1:3) - world_cord5(1:3);

sign1 = sign(vec1_f'*norm_f);
sign2 = sign(vec2_f'*norm_f);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,5) C_proj(1,6) C_proj(1,7) C_proj(1,8)],[C_proj(2,5) C_proj(2,6) C_proj(2,7) C_proj(2,8)],'m');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else
  fill_lev = fill([C_proj(1,5) C_proj(1,6) C_proj(1,7) C_proj(1,8)],[C_proj(2,5) C_proj(2,6) C_proj(2,7) C_proj(2,8)],'m');
  set(fill_lev,'FaceAlpha',0.2); hold on  
end

%face6

edge1_f = world_cord1(1:3) - world_cord2(1:3);
edge2_f = world_cord2(1:3) - world_cord3(1:3);

norm_f = cross(edge1_f,edge2_f);

vec1_f = Cam_t - world_cord1(1:3);
vec2_f = world_cord5(1:3) - world_cord1(1:3);

sign1 = sign(vec1_f'*norm_f);
sign2 = sign(vec2_f'*norm_f);

if sign1 ~= sign2
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,3) C_proj(1,4)],[C_proj(2,1) C_proj(2,2) C_proj(2,3) C_proj(2,4)],'k');
  set(fill_lev,'FaceAlpha',0.7); hold on  
else
  fill_lev = fill([C_proj(1,1) C_proj(1,2) C_proj(1,3) C_proj(1,4)],[C_proj(2,1) C_proj(2,2) C_proj(2,3) C_proj(2,4)],'k');
  set(fill_lev,'FaceAlpha',0.2); hold on   
end
v = getframe;
IM_AR = v.cdata;
end