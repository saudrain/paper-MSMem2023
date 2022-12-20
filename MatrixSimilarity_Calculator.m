%% Calculate Matrix Similarity %%

% Calculates matrix simlarity and ROI similarity of the memory network of a given subject compared to a healthy control
% template

% Input: memory network connectivity matrices 

% Output: 
% 1. MatrixSimilarity.txt which contains matrix similarity values for each
% participant (rows)
% 2. ROIsimilarity.txt contains ROI simiarity for each participantc(rows) and each
% ROI (columns)

%% %%% 1. SET PATHS AND LOAD DATA %%% %%

clear all 

%%%% CHANGE PATH HERE %%%%
addpath('/Users/audrainsp/Library/Mobile Documents/com~apple~CloudDocs/Documents/Science_Projects/RSMemory/MatrixSim_Mem_Nov2020/MSMemNov2020_R/MsMem_Github/') %points to working directory containing memory connectivity matrices, BNA ROI list, and subject list 

%%%% CHANGE PATH HERE %%%%
addpath ('/Users/audrainsp/Library/Mobile Documents/com~apple~CloudDocs/Documents/Science_Projects/RSMemory/MatrixSim_Mem_Nov2020/MSMemNov2020_R/MsMem_Github/nancorrcoef/')  % point to path where nancorrcoef.m lives, which is needed to calculate the correlation coefficient between vectors that have NaN's

%%% load the data 
load('memory_matrices.mat') %there is one 2d matrix per subject in this .mat file 

load('BNA_memory_ROI.mat') % loads the BNA (Brainnetome Atlas) memory network ROIs we are using. Numbers are labels from the Brainnetome Atlas 

subj_list = fileread('subj_list.txt'); % read in subject list 
subjects = strsplit(subj_list)'; % format it 


%% 2. CALCULATE HEALTHY CONTROL TEMPLATE 
% add together the 19 healthy control matrices and divide by 19 to get the
% average healthy control matrix 

mean_HC_matrix = (Matrix_subject29+Matrix_subject30+Matrix_subject31+Matrix_subject32+Matrix_subject33+Matrix_subject34+Matrix_subject35+Matrix_subject36+Matrix_subject37+Matrix_subject38+Matrix_subject39+Matrix_subject40+Matrix_subject65+Matrix_subject66+Matrix_subject67+Matrix_subject68+Matrix_subject69+Matrix_subject70+Matrix_subject71)/19;

%% 3. MATRIX SIMILARITY CALCULATION 
% correlate each individual matrix with healthy control matrix using
% nancorrcoef

for i = 1:length(subjects); % for each subject
    
    Calc_corrcoef = ['corrcoef_sample(i,1) = nancorrcoef(Matrix_subject' subjects{i} '(:),mean_HC_matrix(:));']; %correlate them with the template
    eval(Calc_corrcoef);
    
end

fisherz_sample = atanh(corrcoef_sample); %% fisher transform the output to normalize

dlmwrite('MatrixSimilarity.txt', fisherz_sample, '\t') %% save the output


%% 4. ROI SIMILARITY CALCULATION
% calculate individual subject ROI correlation with mean_HC_matrix ROI connectivity pattern

for i = 1:length(subjects); % for each subject

    for roi = 1:length(BNA_memory_ROI); % for each ROI 
        
        Calc_corrcoef = ['ROI(i, roi) = nancorrcoef(Matrix_subject' subjects{i} '(roi,:),mean_HC_matrix(roi,:));']; % correlate ROI of participant with ROI of template
        
        eval(Calc_corrcoef);
        
        fisherz_sample_ROI(i,roi) = atanh(ROI(i,roi)); % fisher transform 
   
    end
    
end

dlmwrite('ROIsimilarity.txt', fisherz_sample_ROI, '\t'); % save the output 



