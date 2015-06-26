
addpath(genpath('../proposals'))

img=imread('car.jpg');
[proposals, superpixels, image_data, score] = generate_proposals(img); 
% This should take several minutes to compute

figure, hold on;
for i=1:1
    disp(i);
    img_show = img;
    img_show(:,:,1) = img(:,:,1) + 255.* uint8(ismember(superpixels, proposals{i}));
    imshow(img_show);
    pause;
    
end

