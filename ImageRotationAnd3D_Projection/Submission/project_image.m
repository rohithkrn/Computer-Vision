function [I] =  project_image(Str,K,R,t)

%% Scatter Plot
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

%%
Rc = R';
tc = -Rc*t;
P = K*[Rc tc];
Str_Homo = [Str; ones(1,size(Str,2))];
ImProj = P*Str_Homo;

ImProj(1,:) = ImProj(1,:)./ImProj(3,:);
ImProj(2,:) = ImProj(2,:)./ImProj(3,:);

Plane1 = zeros(600);

s1 = size(Str,2);

for i=1:s1
  Plane1(floor(ImProj(2,i)),floor(ImProj(1,i))) = 1;
end

I = Plane1;
imshow(I);

end