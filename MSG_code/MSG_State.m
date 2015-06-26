function [ State_Overlap ] = MSG_State( data, Node_state_num, Video_frame_num )
%MOCS_STATE Summary of this function goes here
%   Detailed explanation goes here
    video_num = size(data,2);
    Node_num = sum(sum(Node_state_num));
    
    State_Overlap = zeros(Node_num, Node_num);
    
    for video_idx = 1:video_num
        for frame_idx = 1:Video_frame_num(video_idx)
            
            load( data{video_idx}.mask_info.maskpath{frame_idx}, 'mask');
            mask_num = Node_state_num(video_idx, frame_idx);
            
            for mask_idx = 1:mask_num
                Current_mask = mask(:,:,mask_idx);
                for next_id = 1:mask_num
                    target_mask = mask(:,:,next_id);
                    Current_idx = MSG_Mask2Idx( video_idx, frame_idx, mask_idx, Node_state_num );
                    target_idx = MSG_Mask2Idx( video_idx, frame_idx, next_id, Node_state_num );
                    
                    State_Overlap(Current_idx, target_idx) = length(find(Current_mask & target_mask)) ...
                        / length(find(Current_mask | target_mask));
                    State_Overlap(target_idx, Current_idx) = State_Overlap(Current_idx, target_idx);
                    
                end
            end
            
        end
    end
%     State_Overlap = exp(-3*State_Overlap);
end

