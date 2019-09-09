% analyze_confidence.m: Analyzes confidence distribution to calculate
% "true" chance level

% general variables
s = [1,2,3,4,6,7,8,9,11,12,13,14,15,16,17,20,22,23,24,25,26,27,28,29,30];
total_points_rel = [];
load('FA.mat');

for i=1:length(s)
   disp(sprintf('Running s%i', s(i)));
   item_rec_points = [];
   ass_rec_points = [];
   total_points = zeros(1,12);   
   
   % load DF
   DF_path = sprintf('Z:/IntMem/data/s%i/DF_s%i.xlsx',s(i),s(i));
   [num,txt] = xlsread(DF_path);
   if s(i) == 4 %less trials
       add = zeros(29,20);
       num = [num;add];
       txt(93:121,:) = {zeros(1,1)};
   elseif s(i) == 20 % less trials as well
       add = zeros(3,20);
       num = [num;add];  
       txt(118:121,:) = {zeros(1,1)};
   end
   
   % item_rec
   item_rec_conf = num(:,4)';
   
   % ass_rec
   ass_rec_conf(i,:) = num(:,5);
   ass_rec_corr(i,:) = txt(2:end,12);
   
   cntr = 0;
   for j = 1:length(num)
       if item_rec_conf(j) < 4 && item_rec_conf(j) > 0 % don't take item misses along
           cntr = cntr + 1;
           
           % turn item confidence into points
           if item_rec_conf(j) == 1
               item_rec_points(cntr) = 3;
           elseif item_rec_conf(j) == 2
               item_rec_points(cntr) = 2;
           elseif item_rec_conf(j) == 3
               item_rec_points(cntr) = 1;
           end
           
           % turn ass confidence into points
           if strcmp(ass_rec_corr{i,j},'Hit')
               if ass_rec_conf(i,j) == 1 || ass_rec_conf(i,j) == 6
                   ass_rec_points(cntr) = 3;
               elseif ass_rec_conf(i,j) == 2 || ass_rec_conf(i,j) == 5
                   ass_rec_points(cntr) = 2;
               elseif ass_rec_conf(i,j) == 3 || ass_rec_conf(i,j) == 4
                   ass_rec_points(cntr) = 1;
               end
           elseif strcmp(ass_rec_corr{i,j},'Miss')
               ass_rec_points(cntr) = 0;
           elseif strcmp(ass_rec_corr{i,j},'No response')
               ass_rec_points(cntr) = 0;               
           end
       
           % determine amount of occurrences per bin
           if item_rec_points(cntr) == 1
               if ass_rec_points(cntr) == 0
                   total_points(1) = total_points(1) + 1;
               elseif ass_rec_points(cntr) == 1
                   total_points(2) = total_points(2) + 1;
               elseif ass_rec_points(cntr) == 2
                   total_points(3) = total_points(3) + 1;
               elseif ass_rec_points(cntr) == 3
                   total_points(4) = total_points(4) + 1;
               end
           elseif item_rec_points(cntr) == 2
               if ass_rec_points(cntr) == 0
                   total_points(5) = total_points(5) + 1;
               elseif ass_rec_points(cntr) == 1
                   total_points(6) = total_points(6) + 1;
               elseif ass_rec_points(cntr) == 2
                   total_points(7) = total_points(7) + 1;
               elseif ass_rec_points(cntr) == 3
                   total_points(8) = total_points(8) + 1;
               end
           elseif item_rec_points(cntr) == 3
               if ass_rec_points(cntr) == 0
                   total_points(9) = total_points(9) + 1;
               elseif ass_rec_points(cntr) == 1
                   total_points(10) = total_points(10) + 1;
               elseif ass_rec_points(cntr) == 2
                   total_points(11) = total_points(11) + 1;
               elseif ass_rec_points(cntr) == 3
                   total_points(12) = total_points(12) + 1;
               end
           end
       end              
   end
   
   % calculate relative percentage of occurrences
   total_item1 = sum(total_points(1:4));
   total_item2 = sum(total_points(5:8));
   total_item3 = sum(total_points(9:12));
    
   total_points_rel(i,:) = fa_rate(i)*[(total_points(1)/total_item1)*dist_rel(i,1)*1,(total_points(2)/total_item1)*dist_rel(i,1)*2,(total_points(3)/total_item1)*dist_rel(i,1)*3,(total_points(4)/total_item1)*dist_rel(i,1)*4, ...
       (total_points(5)/total_item2)*dist_rel(i,2)*2,(total_points(6)/total_item2)*dist_rel(i,2)*3,(total_points(7)/total_item2)*dist_rel(i,2)*4,(total_points(8)/total_item2)*dist_rel(i,2)*5, ...
       (total_points(9)/total_item3)*dist_rel(i,3)*3,(total_points(10)/total_item3)*dist_rel(i,3)*4,(total_points(11)/total_item3)*dist_rel(i,3)*5,(total_points(12)/total_item3)*dist_rel(i,3)*6];
end

% make final calculations
final = mean(total_points_rel);
disp(sum(final));