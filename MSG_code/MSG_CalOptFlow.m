function [ video_Optflow ] = MSG_CalOptFlow( video, candidate_path)
% obtain the optical flow
    
    alpha = 0.012;
    ratio = 0.75;
    minWidth = 20;
    nOuterFPIterations = 7;
    nInnerFPIterations = 1;
    nSORIterations = 30;
    video_Optflow.pathroot = candidate_path;
    
    para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

    for i =1:video.frame_num -1
        video_Optflow.flowpath{i} = [video_Optflow.pathroot video.files(i).name(1:end-4) '_Optflow.mat'];
        if (exist(video_Optflow.flowpath{i}, 'file')) 
            disp(['load opical flow frame #', num2str(i)]);
        else
            disp(['opical processing frame #', num2str(i)]);
            img1 = im2double(imread(video.framepath{i}));
            img2 = im2double(imread(video.framepath{i+1}));

            [u,v,warpI2] = Coarse2FineTwoFrames(img1, img2, para);
            video_Optflow.flowpath{i} = [video_Optflow.pathroot video.files(i).name(1:end-4) '_Optflow.mat'];
            save(video_Optflow.flowpath{i},'u', 'v');
        end
    end

end

