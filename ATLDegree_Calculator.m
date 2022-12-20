%% Calculate Degree of To-Be-Resected Regions to the rest of the Memory Network %%

% this script extracts degree from to-be-resected regions to all memory ROIs across connection density thresholds, and from to-be-resected regions to each other
% It then subtracts them to get ATL degree to the memory network,
% correcting for degree between to-be-resected ROIs 

% Input: memory network connectivity matrices .mat

% Output: 
% 1. LATL_degree.txt: degree from to-be-resected ROIs in the left hemisphere
% to the rest of the memory network. Each row is a participant, each column
% a threshold (5, 10, 15, 120, 25, 30, 35, 40, 45)

% 2. RATL_degree.txt: degree from to-be-resected ROIs in the right hemisphere
% to the rest of the memory network. Each row is a participant, each column
% a threshold (5, 10, 15, 120, 25, 30, 35, 40, 45)


%% %%% 1. SET PATHS AND LOAD DATA %%% %%

clear all;

%%%% CHANGE PATH HERE %%%%
addpath('/Users/audrainsp/Documents/software/BCT/2019_03_03_BCT/') %points to brain connectivity toolbox on your local machine 

%%%% CHANGE PATH HERE %%%%
addpath('/Users/audrainsp/Library/Mobile Documents/com~apple~CloudDocs/Documents/Science_Projects/RSMemory/MatrixSim_Mem_Nov2020/MSMemNov2020_R/MsMem_Github/') %points to working directory containing memory connectivity matrices and subject list 

load('memory_matrices.mat') %ther_e is one 2d matrix per subject in this .mat file 

subj_list = fileread('subj_list.txt'); % read in subject list 
subjects = strsplit(subj_list)'; % format it 

%% 2. STACK LOADED MATRICES %% 
%%%put all matrices into 1 3d matrix that can be indexed for thresholding

for i = 1:length(subjects);
    
    make_3d_array = ['matrices(:,:,i) = Matrix_subject' subjects{i} '(:,:);'];
    
    eval(make_3d_array);
    
end

%% 3. DEGREE CALCULATION OF TO-BE-RESECTED ROIS TO ALL MEMORY NETWORK ROIS %%  

count = 0 

for cost = [0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45]; %thresholds
    
    for subj = 1:length(subjects); %for each subject 
        
        thresholded_matrices(:,:,subj) = threshold_proportional(matrices(:,:,subj), cost); %threshold top x % of connections
       
        binarized_matrices(:,:,subj) = weight_conversion(thresholded_matrices(:,:,subj),'binarize'); %binarize the matrices
        
        degree(:,:,subj) = degrees_und(binarized_matrices(:,:,subj));  %calculate degree
   
    end
    
    reshaped_matrix_degree = reshape(degree,size(degree,1)*size(degree,2),size(degree,3)); %reshape 3d matrix into 2d matrix, nodexsubject
   
    reshaped_matrix_degree = reshaped_matrix_degree'; %transpose into subjxnode
   
    count = count + 1
   
    degree_across_thresholds(:,:,count) = reshaped_matrix_degree; %save in third dimension 
    
    LTBR_degree_to_allROIs(:,:,count) = reshaped_matrix_degree(:,[25, 29, 35, 37, 41, 57, 59]); % left hem memory ROIs of to-be-resected regions
    
    RTBR_degree_to_allROIs(:,:,count) = reshaped_matrix_degree(:,[26, 30, 36, 38, 42, 58, 60]); % right hem memory ROIs of to-be-resected regions

end



%% 4. DEGREE CALCULATION OF TO-BE-RESECTED ROIS TO EACH OTHER %%
%%% thresholds and binarizes and then subsets and then degree calc 

count = 0 

for cost = [0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45]; %thresholds
    
    for subj = 1:length(subjects); %for each subject 
        
        thresholded_matrices(:,:,subj) = threshold_proportional(matrices(:,:,subj), cost); %threshold entire matrix
        
        binarized_matrices(:,:,subj) = weight_conversion(thresholded_matrices(:,:,subj),'binarize'); % binarize thresholded matrix
        
        LTBR_matrices = binarized_matrices([25, 29, 35, 37, 41, 57, 59],[25, 29, 35, 37, 41, 57, 59],:); % subset network matrix to look at the 7 TBR ROIs in left hem 
        RTBR_matrices = binarized_matrices([26, 30, 36, 38, 42, 58, 60],[26, 30, 36, 38, 42, 58, 60],:); % right hem ROIs, for RTLE
       
        Ldegree(:,:,subj) = degrees_und(LTBR_matrices(:,:,subj));  %calculate degree between just the TBR ROIs in left hem 
        Rdegree(:,:,subj) = degrees_und(RTBR_matrices(:,:,subj));  %calculate degree between just the TBR ROIs in right hem 
   
    end
    
    reshaped_matrix_Ldegree = reshape(Ldegree,size(Ldegree,1)*size(Ldegree,2),size(Ldegree,3)); %reshape 3d matrix into 2d matrix, nodexsubject
    reshaped_matrix_Rdegree = reshape(Rdegree,size(Rdegree,1)*size(Rdegree,2),size(Rdegree,3)); %reshape 3d matrix into 2d matrix, nodexsubject
    
    reshaped_matrix_Ldegree = reshaped_matrix_Ldegree'; %transpose into subjxnode
    reshaped_matrix_Rdegree = reshaped_matrix_Rdegree'; %transpose into subjxnode
    
    count = count + 1
    
    LTBR_degree_to_LTBR(:,:,count) = reshaped_matrix_Ldegree; %save in third dimension 
    RTBR_degree_to_RTBR(:,:,count) = reshaped_matrix_Rdegree; %save in third dimension 

end

%% 5. DEGREE OF TO-BE-RESECTED ROIS TO THE REST OF THE MEMORY NETWORK, EXCLUDING CONNECTIONS TO OTHER TO-BE-RESECTED ROIS %% 

LTBR_degree_to_network =  LTBR_degree_to_allROIs(:,:,:) - LTBR_degree_to_LTBR(:,:,:); %correct for connections between TBR ROIs in left hem 
RTBR_degree_to_network =  RTBR_degree_to_allROIs(:,:,:) - RTBR_degree_to_RTBR(:,:,:); %correct for connections between TBR ROIs in right hem 

%%% sum degree across to-be-resected ROIs 
LTBR_degree_to_network_sum = sum(LTBR_degree_to_network,2); %sub degree across the to-be-resected ROIs in left hem, to get a single measure of ATL degree
RTBR_degree_to_network_sum = sum(RTBR_degree_to_network,2); %sub degree across the to-be-resected ROIs in left hem, to get a single measure of ATL degree 

%%% reshape matrices
LTBR_degree_subjxcost = reshape(LTBR_degree_to_network_sum,size(LTBR_degree_to_network_sum,1)*size(LTBR_degree_to_network_sum,2),size(LTBR_degree_to_network_sum,3));
RTBR_degree_subjxcost = reshape(RTBR_degree_to_network_sum,size(RTBR_degree_to_network_sum,1)*size(RTBR_degree_to_network_sum,2),size(RTBR_degree_to_network_sum,3));


%% 6. SAVE THE OUTPUT %% 
%%% into .txt files, reflecting ATL degree for each participant (row) at
%%% each cost threshold (columns, 5-45% top connection density thresholds)

dlmwrite('LATL_degree.txt', LTBR_degree_subjxcost, '\t'); % left hem output
dlmwrite('RATL_degree.txt', RTBR_degree_subjxcost, '\t'); % right hem output 



