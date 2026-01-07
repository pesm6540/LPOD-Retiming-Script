%% Header
% @project  LPOD Wireless Data Polishing
%
% @file     LPOD_DataPolishing.m
% @author   Percy Smith, percy.smith@colorado.edu   
% @brief    Firmware that fixes repeat times & creates better format! 
%
% @date     January 7, 2026
% @version  3.0.0
% @log      Commented code & made more generalizable 
%% Terminate
clear 
close all

%% Importing data & assigning proper variables 
PODID_Data = readtable("PODID.csv", 'Delimiter', {',', ' '}); 
% NOTE: Depending on file size, you might have to do this differently so
% your computer doesn't crash/wig out. 
    % Method 1: Use command prompt (I recommend this wikihow just swap csv
        % https://www.wikihow.com/Merge-Text-(.Txt)-Files-in-Command-Prompt)
    % Method 2: try combining the csvs to a singular txt & then use a diff
        % function
    % Method 3: I had to do it manually once with a for loop, and it does 
        % suck for sure, cannot lie. But just get it to import them all once & 
        % then combine those lads fr 

% Makes string in format "MM-DD-YYYY hh:mm:ss" & converts to datetime var
DT_DRAFT = string(PODID_Data.Var4) + "-" + string(PODID_Data.Var3) + "-" + ...
     string(PODID_Data.Var5) + " " + string(PODID_Data.Var6); %% This is the string
DT = datetime(DT_DRAFT); % This is the datetime variable

% Removes variables filled with data we no longer need with datetime: 
    % 'Thu','Dec',5,2024,'06:17:08,'GMT-0700','(Mountain','Standard','Time)' 
LPOD = removevars(PODID_Data, {'Var1', 'Var2', 'Var3', 'Var4', 'Var5', 'Var6', 'Var8', 'Var7', 'Var9', 'Var10'});
% Add datetime variable to the start of the table
LPOD = addvars(LPOD, DT, 'Before', 'Var11');

% Create specific variable names
names = {'DateTime', 'Fig1','Fig2','Fig3','AS_Work','AS_Aux','Temp','RH'};
LPOD.Properties.VariableNames = names;

% This is a good save point if you need to tweak the import at all so you 
% can check before running the next section - it takes a minute to run so
% this will make it faster if second section wigs out 

% writetable(LPODB2, 'LPODB2.csv');

%% Fixing DateTime 
% CHANGE THESE:
SENT = 19; % # of rows with the same timestamp (could automate but I'd rather die I think)
t_interval = 10.5; % t interval in seconds

% DO NOT CHANGE:
[len, ~] = size(LPOD); % Finds the table length (# rows)
iterate = len/SENT; % This is the number of times the loop will run :)
n = 1; % Initialize just to be safe

% For loop that will fix the repeating timestamps
for i = 1:1:iterate
    for j = 0:1:SENT-1
        new_date(n,1) = LPOD.DateTime(n) - seconds((SENT-j)*(10.5));
        n = n+1;
    end
end

% Replace DateTime variable & replace with new_date (no repeats!)
LPOD = removevars(LPOD, 'DateTime');
LPOD = addvars(LPOD, new_date, 'Before', 'Fig1');

% Writes table --> csv file with timestamp (similar to YPOD formatting)
writetable(LPOD, 'POD_YYYY-MM-DD.csv');

%% In case you want to check your plots quickly...
% Makes table --> timetable because quick plotting is easier with this
% LPODB2_tt = table2timetable(LPOD);
