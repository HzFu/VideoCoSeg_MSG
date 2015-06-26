function [ video_info ] = MSG_Proprocessing( para )
%MSG_PROPROCESSING Summary of this function goes here
%   Detailed explanation goes here

video_num = numel(para.video_name);
disp('Begin to preprocess the data.');
for i = 1:video_num
    candidate_path = MSG_mkdir([para.temporal_path para.video_name{i} '/propregion/']);
    
    % Read video frames
    video_info_mat = [candidate_path  'video_info.mat'];
    if (~exist(video_info_mat, 'file')) 
        video_info = MSG_ReadFrame([para.video_path para.video_name{i} '/'], para.img_type);
        save(video_info_mat,'video_info');
    else
        load(video_info_mat,'video_info');
    end
    
    % Generate proposals
    mask_mat = [candidate_path  'mask_info.mat'];
    if (~exist(mask_mat, 'file')) 
        mask_info = MSG_GetRegions(video_info, candidate_path);
        save(mask_mat,'mask_info');
    end
    
    % Compute optic flow
    OpticFlow_mat = [candidate_path  'Optflow_info.mat'];
    if (~exist(OpticFlow_mat, 'file')) 
        Optflow_info = MSG_CalOptFlow( video_info, candidate_path);
        save(OpticFlow_mat,'Optflow_info');
    end
end

Cosaliency_mat = [candidate_path  'CoSaliency_Map.mat'];
if (~exist(Cosaliency_mat, 'file')) 
    CoSaliency_Map = MSG_Get_cosaliency(para);
    save(Cosaliency_mat,'CoSaliency_Map');
end

end

