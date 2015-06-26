function [UE, Table_UE] = MSG_Graph_UE( Node_unary, GraphInfo )
%

    Table_UE = zeros(3, sum(GraphInfo.Video_frame_num(:)));

    Video_num = size(GraphInfo.Video_frame_num,1);
    for V_idx = 1:Video_num
        for F_idx =  1:GraphInfo.Video_frame_num(V_idx)
            State_begin = sum(sum(GraphInfo.Node_state_num(1:V_idx-1, :)))...
                +sum(sum(GraphInfo.Node_state_num(V_idx, 1:F_idx-1)));
            State_num = GraphInfo.Node_state_num(V_idx, F_idx);
            Node_idx = sum(GraphInfo.Video_frame_num(1:V_idx-1)) + F_idx; 
            UE{Node_idx} = Node_unary((State_begin+1):(State_begin + State_num))';
            
            Table_UE(1, Node_idx) =V_idx;
            Table_UE(2, Node_idx) =F_idx;
            Table_UE(3, Node_idx) =1;
        end
    end


end

