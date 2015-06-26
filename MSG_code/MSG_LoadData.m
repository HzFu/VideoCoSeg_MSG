function [ video_data] = MSG_LoadData( video_root)
% Load preprocessing data

    load([video_root '/propregion/video_info.mat']);
    load([video_root '/propregion/mask_info.mat']);
    load([video_root '/propregion/Optflow_info.mat']);
    video_data.video_info = video_info;
    video_data.mask_info = mask_info;
    video_data.Optflow_info = Optflow_info;

end

