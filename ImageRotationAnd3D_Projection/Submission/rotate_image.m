function [I2] = rotate_image(I1,theta,p0)

I1 = im2double(I1);

[a,b] = size(I1);

%Corner coordinates before rotation
% tl = [250 250]';
% tr = [250 250+b-1]';
% bl = [250+a-1 250]'; 
% br = [250+a-1 250+b-1]';

%% Rotated image size - Pcr = R*(Pc - Po)
plane1 = zeros(600); 
plane2 = zeros(600);
plane3 = zeros(600);

size_p1 = size(plane1);
size_p2 = size(plane2);
size_p3 = size(plane2);

% top left corner of the image in plane1
start_pt = [250,250]';
plane1(start_pt(1):start_pt(1)+a-1,start_pt(2):start_pt(2)+b-1)= I1;

%theta = pi/4;
p0 = start_pt + p0 - 1 ;

if theta == pi/2 || pi || 3*pi/2
    theta = theta - 0.00001;
end


R = [cos(theta) -sin(theta);
     sin(theta) cos(theta)];
 
% Image center, 
imC = [start_pt(1)+(a/2),start_pt(2)+(b/2)]';

%Vector P0
P0 = p0 - imC;

% Vector Pf 
Pf = R*(p0 - imC);

% Point pf
pf = p0 - Pf;

for i = 1:a
    for j=1:b
        
        % Original Coordiantes
        OC{i,j} = [start_pt(1)+i-1 start_pt(2)+j-1]';
        % Coordinates shifted to p0
        ShC1{i,j} = OC{i,j}+(P0);
        % Coordinates rotated  around p0
        RShC{i,j} = p0 + (R*(ShC1{i,j} - p0));
        %RShC{i,j} = (R*(ShC1{i,j} - p0));
          
       %Rotated Coordinates
       RC{i,j} = round( -Pf + RShC{i,j});
       
       if RC{i,j}(1)>0 && RC{i,j}(2) > 0 && RC{i,j}(1) < size_p1(1) && RC{i,j}(2) < size_p1(2)
       plane2(RC{i,j}(1),RC{i,j}(2)) = plane1(start_pt(1)+i-1,start_pt(2)+j-1);
       end
       
    end
end
        disp('Rotated Corners');
        disp(RC{1,1});
        disp(RC{1,b});
        disp(RC{a,1});
        disp(RC{a,b});

% interpolation
r_cr = [RC{1,1}(1),RC{1,b}(1),RC{a,1}(1),RC{a,b}(1)];
r_lb = floor(min(r_cr));
r_ub = floor(max(r_cr));
c_cr = [RC{1,1}(2),RC{1,b}(2),RC{a,1}(2),RC{a,b}(2)];
c_lb = floor(min(c_cr));
c_ub = floor(max(c_cr));

% for ii = floor(min(RC{1,b}(1))):floor(RC{b,1}(1))
%     for jj = floor(RC{1,1}(2)):floor(RC{a,b}(2))
 for ii = r_lb:r_ub
     for jj = c_lb:c_ub
% for ii = 1:size(RC,1)
%      for jj = 1:size(RC,2)
         
       if ii > 0 && jj > 0 && ii < size_p1(1) && jj < size_p1(2)
%        if RC{ii,jj}(1) > 0 && RC{ii,jj}(2) > 0 && RC{ii,jj}(1) < size_p1(1) && RC{ii,jj}(2) < size_p1(2)
%             MC = imC + R'*(RC{ii,jj}-pf);
         MC = imC + R'*([ii,jj]'-pf); % Rotated coordinates mapped to original image
      
       % Computing neighbor integer pixel coordinates
       mc_xf = floor(MC(1));
       mc_xc = ceil(MC(1));
       mc_yf = floor(MC(2));
       mc_yc = ceil(MC(2));
                  
       pix1 = [mc_xf,mc_yf]';
       pix2 = [mc_xf,mc_yc]';
       pix3 = [mc_xc,mc_yf]';
       pix4 = [mc_xc,mc_yc]';
       
       ip1 = 0; ip2 = 0; ip3= 0; ip4 = 0; 
       if pix1(1)>0 && pix1(1) < 601 && pix1(2) > 0 && pix1(2) <601 
       ip1 = plane1(pix1(1),pix1(2));
       end
       if pix2(1)>0 && pix2(1) < 601 && pix2(2) > 0 && pix2(2) <601 
       ip2 = plane1(pix2(1),pix2(2)); 
       end
       if pix3(1)>0 && pix3(1) < 601 && pix3(2) > 0 && pix3(2) <601 
       ip3 = plane1(pix3(1),pix3(2));
       end
       if pix4(1)>0 && pix4(1) < 601 && pix4(2) > 0 && pix4(2) <601 
       ip4 = plane1(pix4(1),pix4(2));
       end
       
       %pv = (ip1+ip2+ip3+ip4)/4;
       pv1 = (((mc_yc - MC(2))/(mc_yc - mc_yf))*ip1) + (((MC(2)-mc_yf)/(mc_yc - mc_yf))*ip2);  
       pv2 = (((mc_yc - MC(2))/(mc_yc - mc_yf))*ip3) + (((MC(2)-mc_yf)/(mc_yc - mc_yf))*ip4);

       pv = (((mc_xc - MC(1))/(mc_xc - mc_xf))*pv1) + (((MC(1)-mc_xf)/(mc_xc - mc_xf))*pv2);  

       plane3(ii,jj) = pv;
        end
    end
end
 
 I2 = plane3;

figure,subplot(1,3,1),imshow(plane1);title 'Original';
subplot(1,3,2),imshow(plane2); title 'Rotated';
subplot(1,3,3),imshow(plane3); title 'Interpolated & Rotated';

% pcr_tl = R*(tl - p0)
% pcr_tr = R*(tr - p0)
% pcr_bl = R*(bl - p0)
% pcr_br = R*(br - p0)
% 
% pcr = [pcr_tl, pcr_tr, pcr_bl, pcr_br];

end

%%

