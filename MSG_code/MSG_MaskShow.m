function [ I_s ] = MSG_MaskShow( img, mask_final)
%

    [~, ~, obj_num] = size(mask_final);

    if obj_num == 1
        mask = mask_final;

        masky = .3*repmat(~mask,[1 1 3]) + repmat(mask,[1 1 3]);
        img = img .* masky;

        [cx,cy] = gradient(double(mask_final));
        ccc = (abs(cx)+abs(cy))~=0;
        ccc = bwmorph(ccc,'dilate',1);

        I_s = img;
        I_s(:,:,1) = max(I_s(:,:,1),ccc);
        I_s(:,:,2) = min(I_s(:,:,2),~ccc);
        I_s(:,:,3) = min(I_s(:,:,3),~ccc);
    end
    
    if obj_num == 2
        mask = mask_final(:,:,1) | mask_final(:,:,2);

        masky = .3*repmat(~mask,[1 1 3]) + repmat(mask,[1 1 3]);
        img = img .* masky;

        [cx,cy] = gradient(double(mask_final(:,:,1)));
        ccc1 = (abs(cx)+abs(cy))~=0;
        ccc1 = bwmorph(ccc1,'dilate',1);

        [cx,cy] = gradient(double(mask_final(:,:,2)));
        ccc2 = (abs(cx)+abs(cy))~=0;
        ccc2 = bwmorph(ccc2,'dilate',1);

        ccc = ccc1 | ccc2;

        I_s = img;
        I_s(:,:,1) = max(I_s(:,:,1),ccc1);
        I_s(:,:,2) = max(I_s(:,:,2),(ccc2-ccc1));
        I_s(:,:,3) = min(I_s(:,:,3),~ccc);
      
    end
    
    if obj_num == 3
        mask = mask_final(:,:,1) | mask_final(:,:,2) | mask_final(:,:,3);

        masky = .3*repmat(~mask,[1 1 3]) + repmat(mask,[1 1 3]);
        img = img .* masky;

        [cx,cy] = gradient(double(mask_final(:,:,1)));
        ccc1 = (abs(cx)+abs(cy))~=0;
        ccc1 = bwmorph(ccc1,'dilate',1);

        [cx,cy] = gradient(double(mask_final(:,:,2)));
        ccc2 = (abs(cx)+abs(cy))~=0;
        ccc2 = bwmorph(ccc2,'dilate',1);
        
        [cx,cy] = gradient(double(mask_final(:,:,3)));
        ccc3 = (abs(cx)+abs(cy))~=0;
        ccc3 = bwmorph(ccc3,'dilate',1);

        ccc = ccc1 | ccc2 | ccc3;

        I_s = img;
        I_s(:,:,1) = max(I_s(:,:,1),ccc1);
        I_s(:,:,2) = max(I_s(:,:,2),ccc2);
        I_s(:,:,3) = max(I_s(:,:,3),ccc3);
    end
    

end

