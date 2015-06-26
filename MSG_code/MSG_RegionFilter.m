function [ mask_info ] = MSG_RegionFilter( mask_info, region_num_bound, max_thre, min_thre )
% remove the abnormal proposals

    frame_num = size(mask_info.frame, 2);
    
    for frame_idx = 1:frame_num
        disp(['RegionFilter processing frame #', num2str(frame_idx), ' of ' num2str(frame_num)]);
        load(mask_info.regionpath{frame_idx},'org_mask');
        
        [img_w, img_h, org_r_num] = size(org_mask);
        max_size = max_thre * img_w * img_h;
        min_size = min_thre * img_w * img_h;
        temp_list = ones(1, org_r_num);
        
        for i = 1:org_r_num
            temp_mask = org_mask(:,:,i);
            [y,x] = find(temp_mask > 0);    
            
            ob_size = length(find(temp_mask > 0));
            xx = max(x) - min(x);
            yy = max(y) - min(y);
            mask_size = xx * yy;
%             mask_size = size(find(temp_mask > 0),1);
            ratio = max(xx/yy , yy/xx);
            
            if (mask_size > max_size || mask_size < min_size || ratio > 10 || ob_size/mask_size < 0.1)
                temp_list(i) = 0;
            end
        end
        new_list = find(temp_list > 0);
        if length(new_list) > region_num_bound
            new_list = new_list(1:region_num_bound);
        end
        mask_info.frame{frame_idx}.mask_num = length(new_list);
        mask_info.frame{frame_idx}.score = mask_info.frame{frame_idx}.org_score(new_list);
        mask = org_mask(:,:,new_list);
        save(mask_info.maskpath{frame_idx},'mask');
    end
end

