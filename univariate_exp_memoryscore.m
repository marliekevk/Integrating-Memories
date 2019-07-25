%-----------------------------------------------------------------------
% Univariate analyses for IntMem - MvK 2017
%-----------------------------------------------------------------------

s = [1,2,3,4,6,7,8,9,11,12,13,14,15,16,17,20,22,23,24,25,26,27,28,29,30]; 
amount_of_scans = {{679,593},{692,603},{719,630},{700,615},{604,644},{741,635},{723,616},{701,605},{700,625},{722,635},{718,617},{716,613}, ...
    {720,628},{697,616},{695,605},{740,672},{710,625},{694,613},{675,603},{719,638},{690,605},{696,601},{726,623},{695,608},{687,607},{699,615}, ...
    {714,624},{710,611},{712,618},{732,607}}; % amount of scans for each run

for i = 1:length(s)    
    disp(sprintf('Running subject %i',s(i)));
    
    %% Behavioral part
    
    % read in conditions files
    
    % AB encoding
    destination = sprintf('Z:/IntMem/data/s%i/logfiles',s(i));
    cd(destination);
    filename = sprintf('s%i_ABencoding.txt',s(i));    
    fid = fopen(filename);
    
    % read out first header lines
    for j=1:9 
        tline = fgetl(fid); 
    end
      
    % read out informative lines: run 1
    counter = 1;  
    for j=1:64
        tline = fgetl(fid); % read out 1 line        
        if ~isempty(tline)
            Line = textscan(tline, '%s');
        end
        % read in variables
        ABencoding_onsets{1}(j) = str2num(Line{1}{5})/1000;
        
        % AB retrieval only for every 8 trials        
        if j == 8 || j == 16 || j == 24 || j == 32 || j == 40 || j == 48 || j == 56 || j == 64
            ABretrieval_onsets{1}(counter) =  str2num(Line{1}{5})/1000 + 7;
            counter = counter + 1;
        end
    end
    
    % read out extra lines + add null event
    for j=1:11 
        tline = fgetl(fid);
        if j == 1
            Line = textscan(tline, '%s');
            null_event{1}(j) = 0;
            null_event{1}(j+1) = str2num(Line{1}{4})/1000;
        end
    end      
    
    % read out informative lines: run 2
    counter = 1;
    for j=1:56
        tline = fgetl(fid); % read out 1 line        
        if ~isempty(tline)
            Line = textscan(tline, '%s');
        end
        % read in variables
        ABencoding_onsets{2}(j) = str2num(Line{1}{5})/1000;
        
        % AB retrieval only for every 8 trials 
        if j == 8 || j == 16 || j == 24 || j == 32 || j == 40 || j == 48 || j == 56
            ABretrieval_onsets{2}(counter) =  str2num(Line{1}{5})/1000 + 7;
            counter = counter + 1;
        end
    end  

    % Null event
    tline = fgetl(fid); % read out 1 line  
    Line = textscan(tline, '%s');
    null_event{2}(1) = 0;
    null_event{2}(2) = str2num(Line{1}{4})/1000;

    fclose(fid);
    
    % AB retrieval
    filename = sprintf('s%i_ABretrieval.txt',s(i));    
    fid = fopen(filename);    
    
    % read out first header lines
    for j=1:6 
        tline = fgetl(fid); 
    end    

    % run 1
    counter = 1;
    for j=1:8
        % for every 8 lines, get RT and sum to get end of block
        RT = 0;
        for k=1:8
            tline = fgetl(fid); % read out 1 line  
            Line = textscan(tline, '%s'); 
            if length(Line{1}) < 7 % no reponse is given that is divided in two cells
                RT = RT + str2num(Line{1}{5})/1000;
            else
                RT = RT + str2num(Line{1}{6})/1000; 
            end
        end
        ABretrieval_offsets{1}(counter) = ABretrieval_onsets{1}(counter)+RT;
        counter = counter + 1;
    end
    
    % read out first extra lines
    for j=1:6 
        tline = fgetl(fid); 
    end    

    % run 2
    counter = 1;
    for j=1:7
        % for every 8 lines, get RT and sum to get end of block
        RT = 0;
        for k=1:8
            tline = fgetl(fid); % read out 1 line  
            Line = textscan(tline, '%s'); 
            if length(Line{1}) < 7 % no response is given that is divided in two cells
                RT = RT + str2num(Line{1}{5})/1000;
            else
                RT = RT + str2num(Line{1}{6})/1000; 
            end
        end
        ABretrieval_offsets{2}(counter) = ABretrieval_onsets{2}(counter)+RT;
        counter = counter + 1;
    end     
    
    fclose(fid);
    
    % AC encoding
    df = xlsread(sprintf('DF_s%i.xlsx',s(i)));
    AConsets_inc1 = [];
    AConsets_inc_param1_1 = [];
    AConsets_inc_param1_2 = [];
    AConsets_inc_param1_3 = [];
    AConsets_inc_param1_4 = [];
    AConsets_inc2 = [];
    AConsets_inc_param2_1 = [];
    AConsets_inc_param2_2 = [];
    AConsets_inc_param2_3 = [];
    AConsets_inc_param2_4 = [];
    AConsets_con1 = [];
    AConsets_con_param1_1 = [];
    AConsets_con_param1_2 = [];
    AConsets_con_param1_3 = [];
    AConsets_con_param1_4 = [];
    AConsets_con2 = [];
    AConsets_con_param2_1 = [];
    AConsets_con_param2_2 = [];
    AConsets_con_param2_3 = [];
    AConsets_con_param2_4 = [];
    AConsets_rest1 = [];
    AConsets_rest2 = [];

    for j=1:length(df)
        if df(j,4) > 0 && df(j,4) < 7 && ~isnan(df(j,18)) % no responses
            if df(j,20) == 1 % run1
                if df(j,2) < 3 %incongruent trials 
                    AConsets_inc1 = [AConsets_inc1, df(j,11)/1000];
                    AConsets_inc_param1_1 = [AConsets_inc_param1_1, df(j,9)]; % memory
                    AConsets_inc_param1_2 = [AConsets_inc_param1_2, df(j,18)]; % reactivation
                    AConsets_inc_param1_3 = [AConsets_inc_param1_3, df(j,17)]; % RT
                    AConsets_inc_param1_4 = [AConsets_inc_param1_4, df(j,2)]; % for param congruency
                elseif df(j,2) > 3 && df(j,2) < 6 %congruent trials
                    AConsets_con1 = [AConsets_con1, df(j,11)/1000];
                    AConsets_con_param1_1 = [AConsets_con_param1_1, df(j,9)];
                    AConsets_con_param1_2 = [AConsets_con_param1_2, df(j,18)];
                    AConsets_con_param1_3 = [AConsets_con_param1_3, df(j,17)];
                    AConsets_con_param1_4 = [AConsets_con_param1_4, df(j,2)]; % for param congruency
                else % trials of no interest (congruency rating = 3 or 6 (enter))
                    AConsets_rest1 = [AConsets_rest1, df(j,11)/1000];
                end                   
            elseif df(j,20) == 2 % run2
                if df(j,2) < 3 %incongruent trials              
                    AConsets_inc2 = [AConsets_inc2, df(j,11)/1000];
                    AConsets_inc_param2_1 = [AConsets_inc_param2_1, df(j,9)];
                    AConsets_inc_param2_2 = [AConsets_inc_param2_2, df(j,18)];
                    AConsets_inc_param2_3 = [AConsets_inc_param2_3, df(j,17)];
                    AConsets_inc_param2_4 = [AConsets_inc_param2_4, df(j,2)]; % for param congruency
                elseif df(j,2) > 3 && df(j,2) < 6 %congruent trials
                    AConsets_con2 = [AConsets_con2, df(j,11)/1000];
                    AConsets_con_param2_1 = [AConsets_con_param2_1, df(j,9)];
                    AConsets_con_param2_2 = [AConsets_con_param2_2, df(j,18)];
                    AConsets_con_param2_3 = [AConsets_con_param2_3, df(j,17)];
                    AConsets_con_param2_4 = [AConsets_con_param2_4, df(j,2)]; % for param congruency
                else % trials of no interest (congruency rating = 3 or 6 (enter))
                    AConsets_rest2 = [AConsets_rest2, df(j,11)/1000];
                end
            end
        else % no response
            if df(j,20) == 1 % run1
                AConsets_rest1 = [AConsets_rest1, df(j,11)/1000];
            elseif df(j,20) == 2 % run2
                AConsets_rest2 = [AConsets_rest2, df(j,11)/1000];
            end
        end       
    end
    
    % group cell arrays per run        
    AConsets_con = {AConsets_con1,AConsets_con2};
    AConsets_inc = {AConsets_inc1,AConsets_inc2};
    AConsets_con_mem = {AConsets_con_param1_1,AConsets_con_param2_1};
    AConsets_inc_mem = {AConsets_inc_param1_1,AConsets_inc_param2_1};
    AConsets_con_reac = {AConsets_con_param1_2,AConsets_con_param2_2};
    AConsets_inc_reac = {AConsets_inc_param1_2,AConsets_inc_param2_2};
    AConsets_con_RT = {AConsets_con_param1_3,AConsets_con_param2_3};
    AConsets_inc_RT = {AConsets_inc_param1_3,AConsets_inc_param2_3};
    AConsets_con_param = {[AConsets_con_param1_4,AConsets_inc_param1_4],[AConsets_con_param2_4,AConsets_inc_param2_4]};
    AConsets_rest = {AConsets_rest1,AConsets_rest2};

    %% fMRI part
     
    % read in scans   
    for run = 1:2
        cd(sprintf('Z:/IntMem/data/s%i/func/experiment/run%i/',s(i),run));
        scans = dir('swr*.nii');
        rp(run) = dir('rp*.txt');
        for k = 1:amount_of_scans{s(i)}{run}
            all_scans{run}{k} = sprintf('Z:/IntMem/data/s%i/func/experiment/run%i/%s,%i',s(i),run,scans.name,k);
        end
    end
            
    % make directory        
    directory = sprintf('Z:/IntMem/data/s%i/analyses/memscore_con_reac_RT_param_mts8',s(i));
    if ~exist(directory)
        mkdir(directory);
    end
       
    % Model specification     
    matlabbatch{1}.spm.stats.fmri_spec.dir = {directory};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    for run = 1:2
        rp_file = rp(run).name;
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).scans = all_scans{run}';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).name = 'all_trials';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).onset = [AConsets_con{1,run},AConsets_inc{1,run}]';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).duration = ones(length([AConsets_con{1,run},AConsets_inc{1,run}]),1)*3;
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).tmod = 0;    
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(1).name = 'mem';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(1).param = [AConsets_con_mem{1,run},AConsets_inc_mem{1,run}]';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(1).poly = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(2).name = 'con';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(2).param = AConsets_con_param{1,run}';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(2).poly = 1;        
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(3).name = 'reac';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(3).param = [AConsets_con_reac{1,run},AConsets_inc_reac{1,run}]';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(3).poly = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(4).name = 'RT';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(4).param = [AConsets_con_RT{1,run},AConsets_inc_RT{1,run}]';
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(1).pmod(4).poly = 1;         

        if length(AConsets_rest{1,run}) > 0
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).name = 'ACrest';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).onset = AConsets_rest{1,run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).duration = ones(length(AConsets_rest{1,run}),1)*3;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {}); 
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).name = 'ABencoding';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).onset = ABencoding_onsets{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).duration = ones(length(ABencoding_onsets{run}),1)*3;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});  
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).name = 'ABretrieval';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).onset = ABretrieval_onsets{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).duration = [ABretrieval_offsets{run} - ABretrieval_onsets{run}]';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {}); 
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(5).name = 'nulls';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(5).onset = null_event{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(5).duration = ones(length(null_event{run}),1)*10;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(5).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});   
        else % no trials in ACencoding_rest
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).name = 'ABencoding';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).onset = ABencoding_onsets{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).duration = ones(length(ABencoding_onsets{run}),1)*3;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});  
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).name = 'ABretrieval';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).onset = ABretrieval_onsets{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).duration = [ABretrieval_offsets{run} - ABretrieval_onsets{run}]';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {}); 
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).name = 'nulls';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).onset = null_event{run}';
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).duration = ones(length(null_event{run}),1)*10;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end
            
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).multi_reg = {sprintf('Z:/IntMem/data/s%i/func/experiment/run%i/%s',s(i),run,rp_file)};
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    end
    
    % Model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    % Contrasts
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat')); 
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'memory';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'memoryxcongruency';
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 1 0 0 0 -1];
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'congruency';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'reactivationxcongruency';
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 1 0 0 0 -1];
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'reactivation';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'RT';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    % run batch
    spm('defaults', 'FMRI');
    spm_jobman('serial', matlabbatch);
    
    clearvars -except s amount_of_scans;  
end
