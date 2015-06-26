function [ h ] = MSG_DrawList( EMSG_List, data, para, GraphInfo)
%EMSG_DRAWLIST Summary of this function goes here
%   Detailed explanation goes here

frame_num = sum(GraphInfo.Video_frame_num);

for video_idx = 1:para.video_num
    Path_result = MSG_mkdir([para.output_path para.video_name{video_idx}]);
    
    for i = 1:GraphInfo.Video_frame_num(video_idx)
        
        frame_name = data{video_idx}.video_info.files(i).name;
        frame_data = im2double(imread(data{video_idx}.video_info.framepath{i}));
        
        [im_h, im_w, im_c] = size(frame_data);
        
        load(data{video_idx}.mask_info.maskpath{i}, 'mask');
            
        node_idx = i + sum(GraphInfo.Video_frame_num(1:video_idx-1));
        
        mask_final = zeros([im_h, im_w, GraphInfo.Obj_num]);
        
        for obj_idx = 1:GraphInfo.Obj_num
            temp_mask = mask(:,:,EMSG_List(node_idx+ (obj_idx-1)*frame_num));
            imwrite(temp_mask,[Path_result  '/' frame_name(1:end-4) '_obj_' num2str(obj_idx) '.png']);
            mask_final(:,:,obj_idx) = temp_mask;
        end
        
        Segimg = MSG_MaskShow( frame_data, mask_final);
        
        imwrite(Segimg,[Path_result  '/' frame_name(1:end-4) '_result.png']);
    end
end
h=1;
end

