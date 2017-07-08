function [rows,cols] = corner(I1,thresh,supp_window)
 
I = rgb2gray(im2double(I1));

%% Image Gradients
derX = [-1 0 1];
derY = [-1 0 1]';

Ix = conv2(I,derX,'same');
Iy = conv2(I,derY,'same');

%% Harris Cornerness
rows = [];
cols = [];
sigma_corner = 1;
winsz_corner = 5;
% k_corner = 0.1;
Ixx = Ix.^2;
Iyy = Iy.^2;
Ixy = Ix.*Iy;

Gf = fspecial('gaussian',[winsz_corner],sigma_corner);
Ixxw = conv2(Ixx,Gf,'same');
Ixyw = conv2(Ixy,Gf,'same');
Iyyw = conv2(Iyy,Gf,'same');

Mc = zeros(size(Ix));

for i=1:size(Ix,1)
    for j=1:size(Ix,2)
        % construct the Harris matrix for this pixel
        A = [Ixxw(i,j) Ixyw(i,j);Ixyw(i,j) Iyyw(i,j) ];
        [~,D] =  eig(A);
        lambda = diag(D);
        lambda1(i,j) =  lambda(1);
        lambda2(i,j) =  lambda(2);
        %Mc(i,j) = det(A) - ((k_corner)*(trace(A)^2));
%         if lambda(1) > thresh && lambda(2) > 0.2
         if lambda(1) > thresh 
        rows = [rows i];
        cols = [cols j];
        end
    end
end
%corners_values = im2uint8(Mc)*255/max(max(Mc));
% figure; imshow((corners_values)); title('Cornerness');

figure,imshow(I); title 'Corners Without Suppression'; hold on;
plot(fliplr(cols),rows,'rx');

%% Non Maxima Suppression
row_s = [];
col_s = [];
% supp_window = 15;
[s1,s2] = size(lambda1);
l1zp =  zeros(s1+supp_window-1,s2+supp_window-1);
[s1,s2] = size(l1zp);
l1zp(ceil(supp_window/2):s1-floor(supp_window/2),ceil(supp_window/2):s2-floor(supp_window/2)) = lambda1;

% for i=1+floor(win_sz/2):size(Ix,1)+floor(win_sz/2)
%     for j=1+floor(win_sz/2):size(Ix,2)+floor(win_sz/2)
%        if lambda1(i,j) > 0.10 && lambda2(i,j) > 0.2
%           l1n = lambda1(i-floor(win_sz/2):i+floor(win_sz/2),j-floor(win_sz/2):j+floor(win_sz/2)); 
%           if lambda1(i,j) == max(l1n(:))
%               row_s = [row_s i];
%               col_s = [col_s j];
%           end
%        end
%     end
% end

for i=1+floor(supp_window/2):size(Ix,1)+floor(supp_window/2)
    for j=1+floor(supp_window/2):size(Ix,2)+floor(supp_window/2)
       if l1zp(i,j) > 0.10 
           %&& lambda2(i,j) > 0.2
          l1n = l1zp(i-floor(supp_window/2):i+floor(supp_window/2),j-floor(supp_window/2):j+floor(supp_window/2)); 
          if l1zp(i,j) == max(l1n(:))
              row_s = [row_s i-floor(supp_window/2)];
              col_s = [col_s j-floor(supp_window/2)];
          end
       end
    end
end
figure,imshow(I); title 'Corners with suppression'; hold on;
plot(fliplr(col_s),row_s,'rx');

end
%%

% figure; imshow((lambda1)); title('lambda1');
% figure; imshow((lambda2)); title('lambda2');
% 
% figure, stem(corners_values(:),'r'); hold on;
% stem(lambda1(:),'g'); hold on;
% stem(lambda2(:),'b'); hold on;