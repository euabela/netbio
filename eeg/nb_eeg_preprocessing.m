function nb_eeg_preprocessing(fnames, outdir)
% PURPOSE 
% Preprocesses raw EEG data available in BrainVision format.
% detrends, re-references (to the median) and saves data in Fieldtrip structure.
%
% INPUTS
% - fnames: full filenames to continous EEG recordings
% - outdir: directory to move preprocessed EEG to
%
% OUTPUTS
% - EEG in Fieldtrip format
%
% DEPENDENCIES
% - SPM12 (https://www.fil.ion.ucl.ac.uk/spm/)
% - FieldTrip (fieldtriptoolbox.org)
%
% USAGE
% >> nb_eeg_preprocessesing;
% >> nb_eeg_preprocessing('myeeg.mat','mydrive/mydir');
%
%------------------------------------------------------------------------
% (c) Eugenio Abela, MD / Richardson Lab

%% Select data and output directory
%------------------------------------------------------------------------

if nargin <1
    fnames = spm_select(Inf,'.mat$','Select data to preprocess...');
    outdir = spm_select(Inf,'dir','Select output directory...');
end

%% Preprocess
%-------------------------------------------------------------------------

for fi = 1:size(fnames,1)
    
    % Load data
    %---------------------------------------------------------------------- 
    cfg            = [],
    cfg.dataset    =(fnames(fi,:));
    
    % Detrend and re-reference to median (less prone to outliers)
    %----------------------------------------------------------------------  
    cfg            = [];
    cfg.detrend    = 'yes';
    cfg.reref      = 'yes';
    cfg.refchannel = 'all';
    cfg.refmethod  = 'median';
    eeg            = ft_preprocessing(cfg,eeg);
    
    % Downsample
    %----------------------------------------------------------------------  
    cfg            = [];
    cfg.resamplefs = 1000;
    eeg            = ft_resampledata(cfg,eeg);

    % Rename and save as Fieldtrip data structure
    %----------------------------------------------------------------------
    [~, namIn, ~] = fileparts(eeg2prepro(filenum,:));
    
    if length(namIn) == 12
        namOut = [namIn(1:end-2) '0' namIn(end-1:end)];  
    elseif length(namIn) == 11
        namOut = [namIn(1:end-1) '00' namIn(end)];   
    elseif length(namIn) == 13
        namOut = namIn;
    end
    
    outname     = [outdir '/fteeg_' namOut '.mat'];
    save(outname,'eeg');
    
end
