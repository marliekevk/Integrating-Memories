% analyze_fa.m: Analyzes false memory distribution to calculate
% "true" chance level

s = [1,2,3,4,6,7,8,9,11,12,13,14,15,16,17,20,22,23,24,25,26,27,28,29,30];
%fa_conf_all = [];

for i=1:length(s)
   disp(sprintf('Running s%i', s(i)));

   if s(i) == 4
       trial_amount = 141;
   %elseif s(i) == 20
   %    trial_amount = 177;
   else
       trial_amount = 180;
   end
   
   % load logfile
   logfile_path = sprintf('Z:/IntMem/data/s%i/logfiles/s%i_recall1.txt',s(i),s(i));
   fileID = fopen(logfile_path,'r');
   % read first 4 lines
   for j=1:4
    tline = fgetl(fileID);
   end
   
   % get lines with information
   cntr = 1;
   fa_conf = [];
   for j = 1:trial_amount
       tline = fgetl(fileID);
       line = textscan(tline, '%s','delimiter', '\t');
        
       if strcmp(line{1}{4},'FA') % false alarm
           fa_conf(cntr) = str2num(line{1}{5});
           cntr = cntr + 1;
       end
   end
   
   fa_rate(i) = (cntr-1)/60;
   if fa_rate(i) > 0
       dist = hist(fa_conf,3);
       dist_rel(i,:) = [dist(1)/sum(dist),dist(2)/sum(dist),dist(3)/sum(dist)];
   else
       dist_rel(i,:) = [0,0,0];
   end
   fclose(fileID);
end

save('FA.mat','fa_rate','dist_rel');
% final calculations
% mean_fa = mean(fa_rate);
% fprintf('Mean FA: %f\n\n',mean_fa);
% dist = hist(fa_conf_all,3);
% dist_rel = [dist(1)/sum(dist),dist(2)/sum(dist),dist(3)/sum(dist)];
% fprintf('Relative FA: ');
% disp(dist_rel);