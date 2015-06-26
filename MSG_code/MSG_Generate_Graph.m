function [ New_UE, New_PI, New_PE, New_Table_UE, New_Edge_table] = MSG_Generate_Graph( UE, PI, PE, GraphInfo, State_Overlap )
%MSS_GENERATE_GRAPH Summary of this function goes here
%   Detailed explanation goes here
    

Node_num = size(GraphInfo.Node_table, 2);
 
    New_UE = [];
    temp_UE_table = GraphInfo.Table_UE;
    New_Table_UE = [];
    for i = 1:GraphInfo.Obj_num
        New_UE = [New_UE UE];
        temp_UE_table(3,:) = i;
        New_Table_UE = [New_Table_UE temp_UE_table];
    end
    
    Newtemp_PI = [];
    temp_Edge_table = GraphInfo.Table_Edge;
    temp_New_Edge_table = [];
    for i = 1:GraphInfo.Obj_num
        Newtemp_PI = [Newtemp_PI PI+Node_num*(i-1)];
        temp_Edge_table(3,:) = i;
        temp_Edge_table(6,:) = i;
        temp_New_Edge_table = [temp_New_Edge_table temp_Edge_table];
    end
    
    Newtemp_PE = [];
    for i = 1:GraphInfo.Obj_num
        Newtemp_PE = [Newtemp_PE PE];
    end

    
    disp('add state term');
    % add state term
    if GraphInfo.Obj_num == 1
        New_PI = Newtemp_PI;
        New_PE = Newtemp_PE;
        New_Edge_table = temp_New_Edge_table;
    else     
        state_edg_num = Node_num *nchoosek(GraphInfo.Obj_num,2);
        State_PI = zeros(2, state_edg_num);
        State_temp_table = zeros(6, state_edg_num);
        
        temp_idx = 1;
        for tar_idx = 1:GraphInfo.Obj_num-1 
            for node_idx = 1:Node_num
                
                        
                bigin_node_idx = node_idx + (tar_idx-1)*Node_num;
                for next_idx = (tar_idx+1) :GraphInfo.Obj_num
    
                    State_temp_table(1,temp_idx) = GraphInfo.Table_UE(1,node_idx);
                    State_temp_table(2,temp_idx) = GraphInfo.Table_UE(2,node_idx);
                    State_temp_table(3,temp_idx) = tar_idx;
                    State_temp_table(4,temp_idx) = GraphInfo.Table_UE(1,node_idx);
                    State_temp_table(5,temp_idx) = GraphInfo.Table_UE(2,node_idx);
                    State_temp_table(6,temp_idx) = next_idx;
                
                    end_node_idx = node_idx + (next_idx-1)*Node_num;
                    State_PI(1,temp_idx) = bigin_node_idx;
                    State_PI(2,temp_idx) = end_node_idx;
                    temp_idx = temp_idx + 1;
                end
            end
        end

        State_PE = [];
        for edge_idx = 1:state_edg_num
            Node_temp_id = mod(State_PI(1,edge_idx), Node_num);
            if Node_temp_id == 0
                Node_temp_id = Node_num;
            end
            id_begion = sum(GraphInfo.Node_table(1:(Node_temp_id-1))) + 1;
            id_end = sum(GraphInfo.Node_table(1:Node_temp_id));
            State_PE{edge_idx} = State_Overlap(id_begion:id_end, id_begion:id_end);
        end

        New_PI = [Newtemp_PI State_PI];
        New_PE = [Newtemp_PE State_PE];
        New_Edge_table = [temp_New_Edge_table State_temp_table];
    end
end

