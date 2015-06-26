function [ PE ] = MSG_Graph_PE( Graph_PI, intra_edge, Node_state_num, Node_intra_affinity, Node_inter_affinity )
% 
    Edge_num = size(Graph_PI,2);
    temp = Node_state_num';
    Frame_node_idx = temp(temp>0);
    
    for edge_idx = 1:Edge_num
        Node_begin = Graph_PI(1,edge_idx);
        Node_end = Graph_PI(2,edge_idx);
        idx1_begion = sum(Frame_node_idx(1:(Node_begin-1))) + 1;
        idx1_end = idx1_begion + Frame_node_idx(Node_begin) - 1;
        idx2_begion = sum(Frame_node_idx(1:(Node_end-1))) + 1;
        idx2_end = idx2_begion + Frame_node_idx(Node_end) - 1;
        
        if intra_edge(edge_idx) == 1  % intra edge
            PE{edge_idx} = Node_intra_affinity(idx1_begion:idx1_end, idx2_begion:idx2_end);
        else % inter edge
            PE{edge_idx} = Node_inter_affinity(idx1_begion:idx1_end, idx2_begion:idx2_end);
        end
        
    end

end

