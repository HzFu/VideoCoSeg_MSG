function [ SalScore ] = MSG_CoSalScore( maskpath )
% obtain the saliency score

    load(maskpath, 'mask');
    
    [mask_H, mask_W, mask_num] = size(mask);
    SalScore = zeros(mask_num , 1);
    
    imsaliency = im2double(imread([maskpath(1:end-9) '_covid.png']));

    for i = 1:mask_num
        temp_m = mask(:,:,i);
        mask_size = sum(sum(temp_m));
        mask_value = sum(sum(temp_m.*imsaliency));
        SalScore(i) = mask_value / mask_size;
    end

end

