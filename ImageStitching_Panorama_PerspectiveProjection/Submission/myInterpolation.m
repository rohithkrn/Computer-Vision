function [pv] =myInterpolation(im_src,MC)
%%
% im_src is the image
% MC are the mapped 2x1 coordinates
%%
[s1,s2,~] = size(im_src);
% Computing neighbor integer pixel coordinates
       mc_xf = floor(MC(1));
       mc_xc = ceil(MC(1));
       mc_yf = floor(MC(2));
       mc_yc = ceil(MC(2));
                  
       pix1 = [mc_xf,mc_yf]';
       pix2 = [mc_xf,mc_yc]';
       pix3 = [mc_xc,mc_yf]';
       pix4 = [mc_xc,mc_yc]';
       
       ip1 = [0 0 0]'; ip2 = [0 0 0]'; ip3= [0 0 0]'; ip4 = [0 0 0]'; 
       if pix1(1)>0 && pix1(1) <= s1 && pix1(2) > 0 && pix1(2) <= s2 
       ip1(1:3) = im_src(pix1(1),pix1(2),:);
       end
       if pix2(1)>0 && pix2(1) <= s1 && pix2(2) > 0 && pix2(2) <= s2 
       ip2(1:3) = im_src(pix2(1),pix2(2),:); 
       end
       if pix3(1)>0 && pix3(1) <= s1 && pix3(2) > 0 && pix3(2) <= s2 
       ip3(1:3) = im_src(pix3(1),pix3(2),:);
       end
       if pix4(1)>0 && pix4(1) <= s1 && pix4(2) > 0 && pix4(2) <= s2 
       ip4(1:3) = im_src(pix4(1),pix4(2),:);
       end
       
       %pv = (ip1+ip2+ip3+ip4)/4;
       pv1 = (((mc_yc - MC(2))/(mc_yc - mc_yf))*ip1) + (((MC(2)-mc_yf)/(mc_yc - mc_yf))*ip2);  
       pv2 = (((mc_yc - MC(2))/(mc_yc - mc_yf))*ip3) + (((MC(2)-mc_yf)/(mc_yc - mc_yf))*ip4);

       pv = (((mc_xc - MC(1))/(mc_xc - mc_xf))*pv1) + (((MC(1)-mc_xf)/(mc_xc - mc_xf))*pv2);  

end