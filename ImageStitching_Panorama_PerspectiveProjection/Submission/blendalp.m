function [Im,q]=blendalp(im1,im2)
    alp=0.7;
    im11 = im1(:,1:end/2,:);
    im12 = im1(:,end/2+1:end,:);

    Im=alp*im11+(1-alp)*im12;
    [~,q,~]=size(Im);
end