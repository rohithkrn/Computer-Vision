function pyr = getPyr(im,type,numlevels)


X = [1 4 6 4 1]/16;

if strcmp(type,'gauss')
pyr =  getGaussPyr(im,X,numlevels);
figure,subplot(1,4,1),imshow(pyr{1}); title 'Level 1 - Gauss Pyr';
subplot(1,4,2),imshow(pyr{2}); title 'Level 2 - Gauss Pyr';
subplot(1,4,3),imshow(pyr{3}); title 'Level 3 - Gauss Pyr';
subplot(1,4,4),imshow(pyr{4}); title 'Level 4 - Gauss Pyr'
elseif strcmp(type,'laplace')
pyr =  getLapPyr(im,X,numlevels);
figure,subplot(1,4,1),imshow(pyr{1}); title 'Level 1 - Laplace Pyr';
subplot(1,4,2),imshow(pyr{2}); title 'Level 2 - Laplace Pyr';
subplot(1,4,3),imshow(pyr{3}); title 'Level 3 - Laplace Pyr';
subplot(1,4,4),imshow(pyr{4}); title 'Level 4 - Laplace Pyr'
end



end


