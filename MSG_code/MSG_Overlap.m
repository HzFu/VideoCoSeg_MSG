function [ Node_affinity ] = MSG_Overlap(Node_affinity, data, Video_ID, Node_state_num)
% compute the overlay between the frames.

    frame_num = data{Video_ID}.video_info.frame_num - 1;
    video_info = Node_state_num(Video_ID, 1:frame_num);
    
    for frame_idx = 1: frame_num-1
        disp(['Overlay processing frame # ', num2str(frame_idx), ' in video # ', num2str(Video_ID)]);
        load( data{Video_ID}.mask_info.maskpath{frame_idx}, 'mask');
        Currframe_mask = mask;
        load( data{Video_ID}.mask_info.maskpath{frame_idx + 1}, 'mask');
        Nextframe_mask = mask;
        load( data{Video_ID}.Optflow_info.flowpath{frame_idx}, 'u', 'v');
        vx = u;
        vy = v;
            
        for region_idx = 1:video_info(frame_idx)
            node_idx = MSG_Mask2Idx( Video_ID, frame_idx, region_idx, Node_state_num );
            Region_mask = Currframe_mask(:,:,region_idx);
            Region_mask_warp = warpFL2(Region_mask,-vx,-vy);
            for Next_region = 1:video_info(frame_idx + 1)
                Node_next = MSG_Mask2Idx( Video_ID, frame_idx + 1, Next_region, Node_state_num );
                Next_mask = Nextframe_mask(:,:,Next_region);
                score = length(find(Region_mask_warp & Next_mask)) ...
                    / length(find(Region_mask_warp | Next_mask));
                
                Node_affinity(node_idx, Node_next) = score;
                Node_affinity(Node_next, node_idx) = score;
                
            end
        end
    end
    
end

