function stroop_analysis
% This function loads the response matrix (respMat) created by the function stroop_experiment to perform analysis. 
%
% Reminder: 
% RespMat has following structure:
%            1st row = written word: "RED"/"ROT" = 1, "GREEN"/"GRÜN" = 2
%            2nd row = visual color: red = 1, green = 2
%            3rd row = language: English = 1, German = 2
%            4th row = key press: left arrow = 1, right arrow = 2
%            5th row = reaction time (sec)
% ------------------------------------------------------------------------
% CONTENT:
%       1. Creating new Matrix called combMat combining respMat + Accuracy & Congruency
%           1.1) Accuracy (ACC) 
%                   Adding row that reflects if participant pressed correct button ("RED"/"ROT"-left arrow, "GREEN"/"GRÜN"-right arrow).
%                   --> row 6 of combMat: correct="1", wrong="0"
%           1.2) Congruence (ACC) 
%                   Adding row that reflects if written word was equal to visual color displayed ("RED"/"ROT"-red color,"GREEN"/"GRÜN"-green color).
%                   --> row 7 of combMat: congruent="1", incongruent="0"
%
%       2) Descriptive data: 
%           2.1) Calculating the mean (M) and standard deviation (SD) across participants for Reaction Time (RT) & Accuracy (ACC).
%           2.2) Creating Figure 1: Bar chart for visualising RT (M & SD). 
%                Creating Figure 2: Bar chart for visualising Accuracy (M & SD).
%
%       3) Statistical Analysis: 
%                Preparation: Using provisorial tables to order matrices for anova2 for Reaction Time (RT) and Accuracy (ACC)
%                Calculating Two-factorial ANOVA for Reaction Time and Accuracy to get Main and Interaction Effects.  
%--------------------------------------------------------------------------
%
%       Inputs: none
%       Outputs: none
%
%   (c) Elena Pavlenko
%
%--------------------------------------------------------------------------
% initialization
% -------------------------------------------------------------------------

nPart   =    0;    
respMat =   [];

% loading input per participant
% can be changed to smaller number (for example max. number used in experiment) for slower computers
for id = 1:999
    
    % loading file of the participants one by one in temporary matrix (tempMat)
    % accumulating them inside respMat
    fname = strcat('respMat_', sprintf('%d',id), '.dat');
    if exist(fname)
        nPart = nPart+1;
        tempMat = load(fname, 'respMat_', sprintf('%d',id), '.dat');            
        respMat = horzcat(respMat,tempMat);
    end
end

%-------------------------------------------------------------------------
%                           1.1 Accuracy
%-------------------------------------------------------------------------

% Calculate amount of rows in response matrix
[~, numTrials] = size(respMat);

% Create empty vector for saving accuracy
accuracy = nan(1, numTrials);

% If answer correct ("RED"/"ROT" and left key, "GREEN"/"GRÜN" and right key pressed) then 1, if wrong then 0
for i = 1:numTrials
    if respMat(1,i) == respMat(4,i)
        accuracy(i) = 1;
    else 
        accuracy(i) = 0;
    end
end

%-------------------------------------------------------------------------
%                           1.2 Congruence
%-------------------------------------------------------------------------

% Create empty vector for saving congruence
congruence = nan(1, numTrials);

% If shown combination is congruent (word "RED"/"ROT" and color red, word "GREEN/GRÜN" and color green) then 1, if not then 0
for i = 1:numTrials
    if respMat(1,i) == respMat(2,i)
        congruence(i) = 1;
    else 
        congruence(i) = 0;
    end
end

%--------------------------------------------------------------------------
%                 New matrix with accuracies and congruence
%--------------------------------------------------------------------------

% Combine respMat with new row of accuracies (6th) & new row of congruence (7th) 
combMat = [respMat; accuracy; congruence];

% combMat has now following structure:
%            1st row = written word: "RED"/"ROT" = 1, "GREEN"/"GRÜN" = 2
%            2nd row = visual color: red = 1, green = 2
%            3rd row = language: English = 1, German = 2
%            4th row = key press: left arrow = 1, right arrow = 2
%            5th row = reaction time (sec)
%            6th row = accuracy: accurate = 1, inaccurate = 0
%            7th row = congruence: congruency = 1, incongruency = 0

%-------------------------------------------------------------------------
%                       2. Descriptive data (means & SD)
%-------------------------------------------------------------------------

% Create empty matrix for descriptive data
descMat = nan(5, 4);

%----------------------2.1.1 Reaction Times (RT)-----------------------------
% Reminder: Reaction times are noted in 5th row of combMat

% Reaction times calculation of...
    % (A)   ...mean and SD over all trials
    % (B)   ...mean and SD over congruent trials ("RED"/"ROT" displayed in red color, "GREEN"/"GRÜN" displayed in green color)
    % (C)   ...mean and SD over ingruent trials ("RED"/"ROT" displayed in green color, "GREEN"/"GRÜN" displayed in red color)
    % (D)   ...mean and SD over English words
    % (E)   ...mean and SD over German words

% (A) over all trials
descMat(1,1)=mean(combMat(5,:));                                            % mean (M)
descMat(1,2)=std(combMat(5,:));                                             % standard deviation (SD)

% (B) over congruent trials (7th row of combMat)
descMat(2,1)=mean(combMat(5,combMat(7,:)==1));                              % M
descMat(2,2)=std(combMat(5,combMat(7,:)==1));                               % SD

% (C) over incongruent trials (7th row of combMat)
descMat(3,1)=mean(combMat(5,combMat(7,:)==0));                              % M
descMat(3,2)=std(combMat(5,combMat(7,:)==0));                               % SD

% (D) over English trials (3rd row of combMat)
descMat(4,1)=mean(combMat(5,combMat(3,:)==1));                              % M
descMat(4,2)=std(combMat(5,combMat(3,:)==1));                               % SD

% (E) over German trials (3rd row of combMat)
descMat(5,1)=mean(combMat(5,combMat(3,:)==2));                              % M 
descMat(5,2)=std(combMat(5,combMat(3,:)==2));                               % SD

%----------------------------2.1.2 Accuracy----------------------------
% Accuracies are noted in 6th row of combMat

% Accuracy calculation of...
    % (a)   ...mean and SD over all trials
    % (b)   ...mean and SD over congruent trials ("RED"/"ROT" displayed in red color, "GREEN"/"GRÜN" displayed in green color)
    % (c)   ...mean and SD over ingruent trials ("RED"/"ROT" displayed in green color, "GREEN"/"GRÜN" displayed in red color)
    % (d)   ...mean and SD over English words
    % (e)   ...mean and SD over German words
    
% (a) over all trials
    descMat(1,3)=mean(combMat(6,:));                                        % mean (M)
    descMat(1,4)=std(combMat(6,:));                                         % standard deviation (SD)

% (b) over congruent trials (7th row of combMat)
    descMat(2,3)=mean(combMat(6,combMat(7,:)==1));                          % M
    descMat(2,4)=std(combMat(6,combMat(7,:)==1));                           % SD

% (c) over incongruent trials (7th row of combMat)
    descMat(3,3)=mean(combMat(6,combMat(7,:)==0));                          % M 
    descMat(3,4)=std(combMat(6,combMat(7,:)==0));                           % SD

% (d) over English trials (3rd row of combMat)
    descMat(4,3)=mean(combMat(6,combMat(3,:)==1));                          % M
    descMat(4,4)=std(combMat(6,combMat(3,:)==1));                           % SD

% (e) over German trials (3rd row of combMat)
    descMat(5,3)=mean(combMat(6,combMat(3,:)==2));                          % M
    descMat(5,4)=std(combMat(6,combMat(3,:)==2));                           % SD

%-------------------------------------------------------------------------
%                       2.2 Figures for descriptive data
%-------------------------------------------------------------------------

% Figure 1 "Reaction Times"
% Create white bar plot with M and SD (error bars)
figure(1)
hold on
bar(1:5, descMat(:,1), 'w')                                                 % using M from descMat for bars
errorbar(1:5, descMat(:,1),descMat(:,2), 'k.')                              % using M and SD from descMat for error bar
title(sprintf('Reaction Times (N= %d)', nPart))                             % title above graphic with number of participants(nPart)
ylabel('Reaction Times (s)')                                                 % y axis title
set(gca,'fontsize',12, 'XTick',1:5)                                         % setting x axis labels, enlarging font size to 12
set(gca, 'XTickLabel' ,{'Overall','Congruent','Incongruent','English','German'}, 'XTickLabelRotation',40) % set label names, turn them to avoid overlap

% Figure 2 "Accuracy"
% Create white bar plot with M and SD (error bars)
figure(2)
hold on
bar(1:5, descMat(:,3), 'w')                                                 % using M from descMat for bars
errorbar(1:5, descMat(:,3),descMat(:,4), 'k.')                              % using M and SD from descMat for error bar 
title(sprintf('Response Accuracies (N= %d)', nPart))                        % title above graphic with number of participants(nPart)
ylabel('Response Accuracies')                                               % y axis title
set(gca, 'fontsize',12,'XTick',1:5)                                         % setting x axis labels, enlarging font size to 12
set(gca, 'XTickLabel' ,{'Overall','Congruent','Incongruent','English','German'},'XTickLabelRotation',45) % set label names, turn them to avoid overlap


%-------------------------------------------------------------------------
%                   Statistical Analysis: Preparation
%--------------------------------------------------------------------------
% having a 2x2 design we are interested in:

% main effects
%       (1)   congruence (congruent/incongruent) on RT
%       (2)   language (English/German) on RT
%       (3)   congruence (congruent/incongruent) on accuracy
%       (4)   language (English/German) on accuracy
%
% interactions
%       (1&2) congruence and language on RT
%       (3&4) congruence and language on accuracy
% 
% ANOVA2 function for two-way analysis of variance is applied because of its relative handiness for balanced designs
% this function needs a specifically sorted matrix by the form of:
%
%   Congruent   Incongruent
%
%     y111         y121
%     ...          ...      English            
%     y11n         y12n
%
%     y211         y221
%     ...           ...     German
%     y21n         y22n
%
% as we have two dependant variables, we need two seperate matrices for (1) Reaction Time (RT) & (2) Accuracy
% we will use provisorial matrices prepMat -> Mat -> anovaMat to arrive at necessary structure for anova2
%
%-------------------Preparing matrix for Reaction Time ANOVA----------------
% 
% Creation of a provisorial empty RT matrix sorted by congruence
RT_prepMat = nan(numTrials/2,4);

% Reminder: combMat 3th row = language, 5th row = reaction time, 7th row = congruence
% Filling of RT_prepMat:       
RT_prepMat(:,1) = combMat(5,(combMat(7,:) == 1));                           % 1st column = RT of all congruent trials
RT_prepMat(:,2) = combMat(5,(combMat(7,:) == 0));                           % 2nd column = RT of all incongruent trials
RT_prepMat(:,3) = combMat(3,(combMat(7,:) == 1));                           % 3rd column = Language indicator of all congruent trials (linked to 1st column in RT_prepMat)
RT_prepMat(:,4) = combMat(3,(combMat(7,:) == 0));                           % 4th column = Language indicator of all incongruent trials(linked to 2st column in RT_prepMat)
      
% Creation of an empty matrix for RT sorted by combinations of both factors (congruence & language)
RT_Mat= nan(numTrials/4,4);

% Reminder: RT_prepMat 1st column congruent trials, 2nd column incongruent trials, 3rd column = language (English = 1, German = 2)
% Filling of RT_Mat:
RT_Mat(:,1) = RT_prepMat((RT_prepMat(:,3) == 1),1);                         % 1st column = RT of congruent trials in English
RT_Mat(:,2) = RT_prepMat((RT_prepMat(:,3) == 2),1);                         % 2nd column = RT of congruent trials in German
RT_Mat(:,3) = RT_prepMat((RT_prepMat(:,3) == 1),2);                         % 3rd column = RT of incongruent trials in English
RT_Mat(:,4) = RT_prepMat((RT_prepMat(:,3) == 2),2);                         % 4th column = RT of incongruent trials in German

% Sorting to arrive at needed ANOVA2 structure (see above)
RT_anovaMat = [RT_Mat(:,1),RT_Mat(:,3);RT_Mat(:,2),RT_Mat(:,4)];


%-------------------Preparing matrix for Accuracy (ACC) ANOVA--------------

% Creation of an empty provisorial ACC matrix sorted by congruency 
ACC_prepMat = nan(numTrials/2,4);

% Reminder: combMat 3th row = language, 6th row = accuracy, 7th row = congruence
% Filling of ACC_prepMat
ACC_prepMat(:,1) = combMat(6,(combMat(7,:) == 1));                          % 1st column = Accuracy of all congruent trials
ACC_prepMat(:,2) = combMat(6,(combMat(7,:) == 0));                          % 2nd column = Accuracy of all incongruent trials
ACC_prepMat(:,3) = combMat(3,(combMat(7,:) == 1));                          % 3rd column = Language indicator of all congruent trials (linked to 1st column in ACC_prepMat)
ACC_prepMat(:,4) = combMat(3,(combMat(7,:) == 0));                          % 4th column = Language indicator of all incongruent trials (linked to column in ACC_prepMat)

% Creation of an empty matrix for Accuracy sorted by combinations of both factors
ACC_Mat= nan(numTrials/4,4);

% Reminder: ACC_prepMat 1st column congruent trials, 2nd column incongruent trials, 3rd column = language (English = 1, German = 2)
% Filling of ACC_Mat:
ACC_Mat(:,1) = ACC_prepMat((ACC_prepMat(:,3) == 1),1);                      % 1st column = Accuracy of congruent trials in English
ACC_Mat(:,2) = ACC_prepMat((ACC_prepMat(:,3) == 2),1);                      % 2nd column = Accuracy of congruent trials in German
ACC_Mat(:,3) = ACC_prepMat((ACC_prepMat(:,3) == 1),2);                      % 3rd column = Accuracy of incongruent trials in English
ACC_Mat(:,4) = ACC_prepMat((ACC_prepMat(:,3) == 2),2);                      % 4th column = Accuracy of incongruent trials in German

% Sorting according to ANOVA2 structure
ACC_anovaMat = [ACC_Mat(:,1),ACC_Mat(:,3);ACC_Mat(:,2),ACC_Mat(:,4)];

%-------------------------------------------------------------------------
%             Statistical Analysis: Two-factorial ANOVA (anova2)
%-------------------------------------------------------------------------
% We use the function anova2 because of its handiness in our case for a 2x2 design
% We create seperate anovas for RT and ACC 
% In the output, columns represent congruence and rows represent language (look above for table)

% Fig. 3: anova2 for reaction times (RT)
[p_RT, tbl_RT] = anova2(RT_anovaMat,numTrials/4);

% Fig. 4: anova2 for accuracy (ACC)
[p_ACC, tbl_ACC] = anova2(ACC_anovaMat,numTrials/4);

end