% The demo of "Object-based Multiple Foreground Video Co-segmentation"

clear; close all;

addpath(genpath('./external'));
addpath(genpath('./MSG_code'));

%% Set parameters

% project name
para.video_set_name = 'DogDeerAll'; 
% the path for saving the temporal files
para.temporal_path = MSG_mkdir(['./Temp_project/' para.video_set_name '/']);
% video set path
para.video_path = ['./Test_data/' para.video_set_name  '/'];
% video set name
para.video_name = {'DogDeer_2','DogDeer_4'};
% video frame type 
para.img_type = 'jpg';
% result output path
para.output_path = MSG_mkdir(['./Result_file/' para.video_set_name '/']);

% graph parameters
lambda_inter = 0.1; % the inter-video term parameter
lambda_intra = 0.4; % the intra-video term parameter
lambda_overlap = 5; % the state overlap term parameter

% object number
para.obj_num = 2;

% object proposal number 
% (if you change these three parameters, you should delete the temporal files and rebuild them)
para.region_num_bound = 50; % candidate number
para.max_size = 0.7; % max candidate window size 
para.min_size = 0.02; % min candidate window size 

% color histogram parameter
para.numColorHistBins = 22;
para.LBinSize = 100 / para.numColorHistBins;
para.abBinSize = 256 / para.numColorHistBins;
para.LBinEdges = 0:para.LBinSize:100;
para.abBinEdges = -128:para.abBinSize:128;
para.NUM_COLORS = 69;

% HOG histogram parameter
para.hog_bin = 8;
para.hog_angle = 360;
para.hog_L = 1;
para.NUM_HOG = 40;

para.video_num = size(para.video_name,2);

%% Preprocess the data

disp('Preprocessing data.');
video_info = MSG_Proprocessing( para );

if (exist([para.temporal_path 'data.mat'], 'file')) 
    disp('Load the data info.');
    load([para.temporal_path 'data.mat'], 'data');
else
    data = cell(1,para.video_num);
    
    % load the precessing result
    for i = 1:para.video_num
        video_root = [para.temporal_path para.video_name{i}];
        data{i} = MSG_LoadData(video_root);
    end

    % Filter the proposal region
    for i = 1:para.video_num
        disp(['filter the proposal region for video ', num2str(i)]);
        data{i}.mask_info = MSG_RegionFilter( data{i}.mask_info, para.region_num_bound, para.max_size, para.min_size );
    end
    save([para.temporal_path 'data.mat'], 'data');
end

%% setting the graph information
disp('Preprocess the graph information.');
GraphInfo.Video_frame_num = zeros(para.video_num, 1);
for i = 1:para.video_num
    % Exclude the last frame for each video.
    GraphInfo.Video_frame_num(i) = data{i}.video_info.frame_num -1;
end

% the node number for each frame
GraphInfo.Node_state_num = zeros(para.video_num, max(GraphInfo.Video_frame_num));
for i = 1:para.video_num
    for j = 1:GraphInfo.Video_frame_num(i)
        GraphInfo.Node_state_num(i,j) = data{i}.mask_info.frame{j}.mask_num;
    end
end

% the total node number of graph
GraphInfo.Node_num = sum(GraphInfo.Node_state_num(:));

GraphInfo.Obj_num = para.obj_num;
GraphInfo.video_num = para.video_num;

% Idx_table: node Idx, Video_idx, Frame_idx, Mask_idx.
GraphInfo.Idx_table = zeros(3, GraphInfo.Node_num, 'int8');
GraphInfo.Node_table = zeros(1, sum(GraphInfo.Video_frame_num));

idx = 1;
t_idx = 1;
for i = 1:para.video_num
    for j = 1:GraphInfo.Video_frame_num(i)
        GraphInfo.Node_table(t_idx) = data{i}.mask_info.frame{j}.mask_num;
        
        t_idx = t_idx + 1;
        
        for k = 1:data{i}.mask_info.frame{j}.mask_num
            GraphInfo.Idx_table(1,idx) = i;
            GraphInfo.Idx_table(2,idx) = j;
            GraphInfo.Idx_table(3,idx) = k;
            idx = idx+1;
        end
    end
end 

%% Objectness score
if (exist([para.temporal_path 'Node_val_Obj.mat'], 'file')) 
    disp('Load the region proposal value.');
    load([para.temporal_path 'Node_val_Obj.mat']);
else
    disp('Compute the region proposal value.');
    Node_val_Obj = [];
    for i = 1:para.video_num
        for j = 1:GraphInfo.Video_frame_num(i)
            Node_val_Obj = [Node_val_Obj; data{i}.mask_info.frame{j}.score];
        end
    end
    Node_val_Obj = MSG_GaussRescale(Node_val_Obj);
    save([para.temporal_path 'Node_val_Obj.mat'],'Node_val_Obj');
end

%% Motion score
if (exist([para.temporal_path 'Node_val_Mov.mat'], 'file')) 
    load([para.temporal_path 'Node_val_Mov.mat']);
    disp('Load the region motion value.');
else
    disp('Compute the region motion value.');
    Node_val_Mov = [];
    for i = 1:para.video_num
        for j = 1:GraphInfo.Video_frame_num(i)
            temp_a = MSG_MovScore( data{i}.mask_info.maskpath{j}, data{i}.Optflow_info.flowpath{j} );
            Node_val_Mov = [Node_val_Mov; temp_a];
        end
    end
    Node_val_Mov = MSG_GaussRescale(Node_val_Mov);
    save([para.temporal_path 'Node_val_Mov.mat'],'Node_val_Mov');
end

%% Co-saliency value
if (exist([para.temporal_path 'Node_val_Sal.mat'], 'file')) 
    load([para.temporal_path 'Node_val_Sal.mat']);
    disp('Load the region saliency value.');
else
    disp('Compute the region co-saliency value.');
    Node_val_Sal = [];
    for i = 1:para.video_num
        for j = 1:GraphInfo.Video_frame_num(i)
            temp_a = MSG_CoSalScore( data{i}.mask_info.maskpath{j});
            Node_val_Sal = [Node_val_Sal; temp_a];
        end
    end
    Node_val_Sal = MSG_GaussRescale(Node_val_Sal);
    save([para.temporal_path 'Node_val_Sal.mat'],'Node_val_Sal');
end

%% Color distance
if (exist([para.temporal_path 'Node_color_dist.mat'], 'file')) 
    disp('Load the color distance.');
    load([para.temporal_path 'Node_color_dist.mat']);
else
    disp('Compute the color distance.');
    Node_color_hist = zeros(GraphInfo.Node_num, para.NUM_COLORS);
    for i = 1:para.video_num
        for j = 1:GraphInfo.Video_frame_num(i)
            load( data{i}.mask_info.maskpath{j}, 'mask');
            frame_temp = im2double(imread(data{i}.video_info.framepath{j}));
            disp(['Compute the color histogram of frame #', num2str(j), ' in video #', num2str(i)]);
            for k = 1:GraphInfo.Node_state_num(i,j)
                idx = MSG_Mask2Idx( i, j, k, GraphInfo.Node_state_num );
                mask_temp = mask(:,:,k);
                Node_color_hist(idx,:) = MSG_ColorHist( frame_temp, mask_temp, para);
            end
        end
    end

    Node_color_dist = pdist2( Node_color_hist, Node_color_hist, 'chisq' );
    color_mean = mean(mean(Node_color_dist));
    Node_color_dist = exp(-1/color_mean * Node_color_dist); 
    save([para.temporal_path 'Node_color_dist.mat'],'Node_color_dist','Node_color_hist');
end

%% Overlap distance
if (exist([para.temporal_path 'Node_Overlap.mat'], 'file')) 
    load([para.temporal_path 'Node_Overlap.mat']);
    disp('Load the overlap distance.');
else
    disp('Compute the overlap distance.');
    Node_Overlap = zeros(GraphInfo.Node_num, GraphInfo.Node_num);
    for i = 1:para.video_num
        Node_Overlap = MSG_Overlap(Node_Overlap, data, i, GraphInfo.Node_state_num); 
    end
    
    save([para.temporal_path 'Node_Overlap.mat'], 'Node_Overlap');
end


%% State distance
if (exist([para.temporal_path 'State_Overlap.mat'], 'file')) 
    load([para.temporal_path 'State_Overlap.mat']);
    disp('Load the state distance.');
else
    disp('Compute the overlap distance.');
    State_Overlap = MSG_State(data, GraphInfo.Node_state_num, GraphInfo.Video_frame_num); 
    save([para.temporal_path 'State_Overlap.mat'], 'State_Overlap');
end

%% Construct the co-slection graph
Node_unary =  -log(Node_val_Obj .* max(Node_val_Mov, Node_val_Sal) );
Node_inter_affinity = lambda_inter * -log(Node_color_dist);
Node_intra_affinity = lambda_intra * -log( Node_Overlap .* Node_color_dist);

disp('Construct the Graph_UE of graph.');
[Graph_UE, GraphInfo.Table_UE] = MSG_Graph_UE( Node_unary, GraphInfo);
disp('Construct the Graph_PI of graph.');
[Graph_PI, intra_edge, GraphInfo.Table_Edge] = MSG_Graph_PI( GraphInfo.Video_frame_num );
disp('Construct the Graph_PE of graph.');
Graph_PE = MSG_Graph_PE( Graph_PI, intra_edge, GraphInfo.Node_state_num, Node_intra_affinity, Node_inter_affinity );

%% -- MSG model ----
[MSG_UE, MSG_PI, MSG_PE, GraphInfo.Table_UE_new, GraphInfo.Table_Edge_new] = ...
    MSG_Generate_Graph(Graph_UE, Graph_PI, Graph_PE, GraphInfo, lambda_overlap.*State_Overlap);
[MSG_List, ~, ~] = vgg_trw_bp(MSG_UE, MSG_PI, MSG_PE);

MSG_DrawList( MSG_List, data, para, GraphInfo);
save([para.temporal_path 'MSG_List.mat'], 'MSG_List', 'GraphInfo');
