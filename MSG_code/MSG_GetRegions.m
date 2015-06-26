function [ maskinfo ] = MSG_GetRegions(video, candidate_path)
% generate the proposal regions
    addpath(genpath('./external/proposals'));
    
    maskinfo.path = candidate_path;
    for i = 1:video.frame_num
        disp(['region processing frame #', num2str(i)]);    
        
        if (exist([maskinfo.path video.files(i).name(1:end-4) '_region.mat'], 'file')) 
            load([maskinfo.path video.files(i).name(1:end-4) '_region.mat']);
        else
            img = im2double(imread(video.framepath{i}));
            [proposals, superpixels, image_data, score] = generate_proposals(img); 
            diffUnary = diff(score,1,1);
            region_num = find(diffUnary > 0, 1);
            proposals = proposals(1:region_num);
            score = score(1:region_num);
            org_mask = zeros(video.imgheight, video.imgwidth, region_num);
        
            for j = 1:region_num
                temp_mask = ismember(superpixels, proposals{j});
                org_mask(:,:,j) = temp_mask;
            end
            save([maskinfo.path video.files(i).name(1:end-4) '_region.mat'],...
                'org_mask','score','region_num','superpixels', 'image_data');
        end
        maskinfo.frame{i}.org_num = region_num;
        maskinfo.frame{i}.org_score = score;
        maskinfo.regionpath{i} = [maskinfo.path video.files(i).name(1:end-4) '_region.mat'];
        maskinfo.maskpath{i} = [maskinfo.path video.files(i).name(1:end-4) '_mask.mat'];
    end



end



