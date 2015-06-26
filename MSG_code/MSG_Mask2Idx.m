function [ Idx ] = MSG_Mask2Idx( Video_idx, Frame_idx, Mask_idx, Node_state_num )
%
    if Mask_idx > Node_state_num(Video_idx, Frame_idx)
       fprintf('error in range\n');
       keyboard;
    end
    
    Idx = sum(sum(Node_state_num(1:Video_idx-1, :)))...
        +sum(sum(Node_state_num(Video_idx, 1:Frame_idx-1))) + Mask_idx;
    
end

