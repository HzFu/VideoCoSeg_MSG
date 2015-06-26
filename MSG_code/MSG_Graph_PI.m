function [ PI, intra_edge, Table_Edge ] = MSG_Graph_PI( Video_frame_num )
%

    
    
    Node_num = sum(Video_frame_num);
    Video_num = size(Video_frame_num,1);
    Edge_intra_num =  Node_num - Video_num;
    
    Edge_inter_num = 0;
    for i = 1:Video_num-1
        Edge_inter_num = Edge_inter_num + Video_frame_num(i)*(sum(Video_frame_num((i+1):Video_num)));
    end
    PI = uint32(zeros(2, Edge_inter_num + Edge_intra_num));
    intra_edge = zeros(1, Edge_inter_num + Edge_intra_num);
    
    Table_Edge = zeros(6, Edge_inter_num + Edge_intra_num);
    
    PI_idx = 1;
    for i = 1:Video_num
        for j = 1:Video_frame_num(i)
            node_idx = sum(Video_frame_num(1:i-1)) + j; 
            
            if j ~= Video_frame_num(i) 
                % intra edge, only the last frame without intra edge
                Table_Edge(1,PI_idx) = i;
                Table_Edge(2,PI_idx) = j;
                Table_Edge(3,PI_idx) = 1;
                Table_Edge(4,PI_idx) = i;
                Table_Edge(5,PI_idx) = j+1;
                Table_Edge(6,PI_idx) = 1;
                
                PI(1,PI_idx) = node_idx;
                PI(2,PI_idx) = node_idx+1;
                intra_edge(PI_idx) = 1;
                PI_idx = PI_idx + 1;
            end
            
            % inter edge
            rest_node_num = sum(Video_frame_num((i+1):Video_num));
            
            for k = 1:rest_node_num
                
                rest_node_idx = sum(Video_frame_num(1:i)) + k;
                
                Find = 0;
                for video_temp_idx = i+1:Video_num
                    video_idx_all = sum(Video_frame_num(1:video_temp_idx));
                    if video_idx_all >= rest_node_idx && Find == 0
                        video_idxx = video_temp_idx;
                        frame_idxx = video_idx_all-rest_node_idx +1;
                        Find = 1;
                    end
                end
        
                Table_Edge(1,PI_idx) = i;
                Table_Edge(2,PI_idx) = j;
                Table_Edge(3,PI_idx) = 1;
                Table_Edge(4,PI_idx) = video_idxx;
                Table_Edge(5,PI_idx) = frame_idxx;
                Table_Edge(6,PI_idx) = 1;
                
                
                PI(1,PI_idx) = node_idx;
                PI(2,PI_idx) = rest_node_idx;
                PI_idx = PI_idx + 1;
            end
            
        end
    end


end

