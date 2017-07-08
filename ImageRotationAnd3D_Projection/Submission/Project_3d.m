tcw1 = [0,-10,1]';
tcw2 = [0,0,11]';
tcw3 = [-10,0,1]';
tcw4 = [4.5,-4.5,7.77]';
%%
% Compute camera orientation matrix by using the projection formula

% R =[Xa.Xb Ya.Xb Za.Xb;
 %    Xa.Yb Ya.Yb Za.Yb; 
  %   Xa.Zb Ya.Zb Za.Yb];


%%
Rcw1 = [1 0 0;
        0 0 1;
        0 -1 0];
    
Rcw2 = [1 0 0;
        0 -1 0;
        0 0 -1];

Rcw3 = [0 0 1;
        -1 0 0;
        0 -1 0];
Rcw4 = [cos(pi/4) 0.5 -0.5;
        cos(pi/4) -0.5 0.5;
        0 -cos(pi/4) -cos(pi/4)];
%% 
load('teapot.mat');
load('intrinsics.mat');
%%
% [I1] =  project_image(Str,K,Rcw1,t1);
% [I1] =  project_image(Str,K,Rcw2,t2);
% [I1] =  project_image(Str,K,Rcw3,t3);
% [I1] =  project_image(Str,K,Rcw4,t4);

%%
scatter3(Str(1,:),Str(2,:),Str(3,:),'.');
hold on;
plotCamera('Location',tcw1,'Orientation',Rcw1); title 'Cam1';

figure,
scatter3(Str(1,:),Str(2,:),Str(3,:),'.');
hold on;
plotCamera('Location',tcw2,'Orientation',Rcw2); title 'Cam2';

figure,
scatter3(Str(1,:),Str(2,:),Str(3,:),'.');hold on;
plotCamera('Location',tcw3,'Orientation',Rcw3); title 'Cam3';

figure,
scatter3(Str(1,:),Str(2,:),Str(3,:),'.');hold on;
plotCamera('Location',tcw4,'Orientation',Rcw4); title 'Cam4';
hold on;

% stem3(Rcw1(1,1),Rcw1(2,1),Rcw1(3,1),'r');
% hold on; 
% stem3(Rcw1(1,2),Rcw1(2,2),Rcw1(3,2),'g');
% hold on; 
% stem3(Rcw1(1,3),Rcw1(2,3),Rcw1(3,3),'k');
% hold on; 
% scatter3(tcw1(1),tcw1(2),tcw1(3));
% % hold on;
% % plot3(Rcw2(1,:),Rcw2(2,:),Rcw2(3,:));
% % hold on; scatter3(tcw2(1),tcw2(2),tcw2(3));
% % plot3(Rcw3(1,:),Rcw3(2,:),Rcw3(3,:));
% % hold on; scatter3(tcw3(1),tcw3(2),tcw3(3));
% % plot3(Rcw4(1,:),Rcw4(2,:),Rcw4(3,:));
% % hold on; scatter3(tcw4(1),tcw4(2),tcw4(3));

%% orientations wrt to camera frame

Rwc1 = Rcw1';
Rwc2 = Rcw2';
Rwc3 = Rcw3';
Rwc4 = Rcw4';

twc1 = -Rwc1*tcw1;
twc2 = -Rwc2*tcw2;
twc3 = -Rwc3*tcw3;
twc4 = -Rwc4*tcw4;

P1 = K*[Rwc1 twc1];
P2 = K*[Rwc2 twc2];
P3 = K*[Rwc3 twc3];
P4 = K*[Rwc4 twc4];

Str_Homo = [Str; ones(1,size(Str,2))];

ImP1 = P1*Str_Homo;
ImP2 = P2*Str_Homo;
ImP3 = P3*Str_Homo;
ImP4 = P4*Str_Homo;

ImP1(1,:) = ImP1(1,:)./ImP1(3,:);
ImP1(2,:) = ImP1(2,:)./ImP1(3,:);

ImP2(1,:) = ImP2(1,:)./ImP2(3,:);
ImP2(2,:) = ImP2(2,:)./ImP2(3,:);

ImP3(1,:) = ImP3(1,:)./ImP3(3,:);
ImP3(2,:) = ImP3(2,:)./ImP3(3,:);

ImP4(1,:) = ImP4(1,:)./ImP4(3,:);
ImP4(2,:) = ImP4(2,:)./ImP4(3,:);

Plane1 = zeros(600);
Plane2 = zeros(600);
Plane3 = zeros(600);
Plane4 = zeros(600);

s1 = size(Str,2);

for i=1:s1
  Plane1(floor(ImP1(2,i)),floor(ImP1(1,i))) = 1;
  Plane2(floor(ImP2(2,i)),floor(ImP2(1,i))) = 1;
  Plane3(floor(ImP3(2,i)),floor(ImP3(1,i))) = 1;
  Plane4(floor(ImP4(2,i)),floor(ImP4(1,i))) = 1;
end

figure,subplot(2,2,1),imshow(Plane1);title 'Cam1';
subplot(2,2,2),imshow(Plane2);title 'Cam2';
subplot(2,2,3),imshow(Plane3);title 'Cam3';
subplot(2,2,4),imshow(Plane4);title 'Cam4';



