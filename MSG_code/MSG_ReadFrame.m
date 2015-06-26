function [ video] = MSG_ReadFrame( video_path, img_type )
% read frame

    video.files = dir([video_path, '*.', img_type]);
    video.video_path = video_path;
    video.frame_num = numel(video.files);
    img = im2double(imread([video.video_path, video.files(1).name]));
    video.imgwidth = size(img, 2);
    video.imgheight = size(img, 1);
    for i = 1:video.frame_num
        video.framepath{i} = [video.video_path, video.files(i).name];
    end
end

