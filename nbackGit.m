
function nbackVer2(id)
%% User preferences

% NUMBER OF TRIALS & BLOCKS
blocknum=2;     % number of blocks
trialnum=50;     % nbacnumber of trials (must be a multiple of block number)

%% SCREEN
Screen('Preference', 'SkipSyncTests', 1); 
screens=Screen('Screens');
screenNumber=max(screens);
black = BlackIndex(screenNumber);

PsychDebugWindowConfiguration

[w, wRect]=Screen('OpenWindow',screenNumber, black);
[width, height]=Screen('WindowSize', w, []);
[xCenter, yCenter] = RectCenter(wRect);
% Hide the mouse cursor:
% HideCursor;

%% COLOUR PARAMETERS 
colourrgb=255;

%% Stimulus DURATION
stimD =0.5;

%%Durations
% Fixation Duration
fixD = 0.5;

% Blank Screen Duration
blankD = 2;

%%IFI
ifi = Screen('GetFlipInterval',w);

%% TIME & DATE STAMP (for output file)
timeday_stamp=datestr(clock);
time_stamp=str2num([timeday_stamp(end-7:end-6) timeday_stamp(end-4:end-3) timeday_stamp(end-1:end)]);
day_stamp=datenum(date);

%% STIMULUS MATRIX
% 
stim_mat=[1 0; 2 1; 1 2; 2 3; 1 4; 2 5; 1 6; 2 7; 1 8; 2 9; ];
 % repeat matrix based on number of trials per block
stim_mat=repmat(stim_mat,trialnum/size(stim_mat,1),1);

%% PERMUTATION OF MATRIX & SETTING UP BLOCKS
for bn=1:blocknum
    blocks_mat((trialnum*bn-(trialnum-1)):trialnum*bn,:)=stim_mat(randperm(size(stim_mat,1)),:);
end

%% KEYBOARD CHECK & WINDOW PRIORITY
KbCheck;
WaitSecs(0.01);
Priority(MaxPriority(w));

%% TASK VERSIONS & INSTRUCTIONS
% 2-N block instructions
task_instructions='2-N back Task (Even or Odd). \n\n Please press "1" if you think the current number shown has the same features (such as even or odd) compared to the number which was shown two steps before.\n Please press "0" if you think the current number shown (even or odd) does not match the number shown 2 steps before. \n\n Please start answering when the third number has been shown \n\n Press any key to begin to begin.';
% 3 N block instructions
bb_instructions='Please take a moment to relax. \n\n You will now begin the 3N Back task \n\nPlease press "1" if you think the current number shown has the same features (such as even or odd) compared to the number which was shown three steps before.\n Please press "0" if you think the current number shown shown (even or odd) does not match the number shown 2 steps before \n\n \n\n Please start answering when the fourth number has been shown \n\n Press any key to begin to begin.';

%% Fixation Cross

white = WhiteIndex(screenNumber);
fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;

%% PREPARE OUTPUT
output = zeros(size(blocks_mat,1),5);

%% PRESENT INSTRUCTIONS
Screen('TextSize', w, 20);
Screen('TextFont', w, 'Times New Roman');
DrawFormattedText(w, task_instructions,'center', 'center', WhiteIndex(w));

% flip instructions screen
time2flip=0; resp.VBLTimestamp=Screen('Flip',w,time2flip);

% wait for response
t_ini = GetSecs();
while (GetSecs() - t_ini <100)
    keyIsDown = KbCheck; 
    %[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyIsDown == 1
        break
    end
end

%% EXPERIMENTAL TRIALS
% specify starting points for blocks
blocktrialstarts=1:trialnum:size(blocks_mat,1);
% for-loop for blocks
for blocks = 1:blocknum
    % specifying block of trials
    blockstim = blocks_mat(blocktrialstarts(blocks):blocktrialstarts(blocks)+(trialnum-1),:);
    % N-backType
        nbackType = 2;
        
    if blocks == 2
        % N-backType
        nbackType = 3;
    %% PRESENT 3N-BLOCK INSTRUCTIONS
    Screen('TextSize', w, 20);
    Screen('TextFont', w, 'Times New Roman');
    DrawFormattedText(w, bb_instructions,'center', 'center', WhiteIndex(w));       
    % flip instructions screen
    time2flip=GetSecs+.005; pre_instruct.VBLTimestamp=Screen('Flip',w,time2flip);
    
    end
    
    % wait for response
    t_ini = GetSecs();
    while (GetSecs() - t_ini <100)
        keyIsDown = KbCheck; 
        if keyIsDown == 1
            break
        end
    end

    % for-loop for trials
    for trials = 1:trialnum
        
        %% N-back
     %% Stimulus Number: Stores the stimulus value as a string
        if blockstim(trials,2)==1
            stimNum='1';
            elseif blockstim(trials,2)==2
                stimNum='2';
                elseif blockstim(trials,2)==3
                    stimNum='3';
                        elseif blockstim(trials,2)==4
                            stimNum='4';
                                elseif blockstim(trials,2)==5
                                    stimNum='5';
                                        elseif blockstim(trials,2)==6
                                        stimNum='6';
                                            elseif blockstim(trials,2)==7
                                            stimNum='7';
                                                elseif blockstim(trials,2)==8
                                                    stimNum='8';
                                                    elseif blockstim(trials,2)==9
                                                        stimNum='9';
                                    
        end
        % Increase font size
        Screen('TextSize', w, 60);
                         
        %% TRIAL START
        time2flip=0; trialstart.VBLTimestamp=Screen('Flip',w,time2flip);
        
        
        
        %% Fixation Point
        Screen('DrawLines', w, allCoords,lineWidthPix, white, [xCenter yCenter]);
        time2flip=trialstart.VBLTimestamp + fixD -ifi ; pre_instruct.VBLTimestamp=Screen('Flip',w,time2flip);
       
        
              
        %% STIMULUS
      
        DrawFormattedText(w, stimNum,'center', 'center');
        time2flip=pre_instruct.VBLTimestamp+stimD-ifi; stim.VBLTimestamp=Screen('Flip',w,time2flip);
       
        
          %% Stimulus to ISI (blank screen)
        DrawFormattedText(w, '','center', 'center', WhiteIndex(w));
        time2flip=stim.VBLTimestamp+0.5-ifi; isi.VBLTimestamp=Screen('Flip',w,time2flip);
       
           %% RESPONSE OUTPUT (resp = key & rt)
           % No Input given = "3£"
            kbNameResult = '3£'
        t_ini = GetSecs();
        while (GetSecs() - t_ini <2)
            % Stores Time taken to break the while loop
            testTime = GetSecs() - t_ini;
            [keyIsDown, secs,keyCode, deltaSecs] = KbCheck; 
            if keyIsDown == 1  
                
                kbNameResult = KbName(keyCode)
                resp = [str2num(kbNameResult(1)) secs-t_ini];
                break
                
            elseif keyIsDown ==0
                resp = [str2num(kbNameResult(1)) secs-t_ini];
            end
        end
        
            % Calculates the extra amount of time if the while loop was broken
            % before 2 seconds
            
            if testTime <2
                testTime2 = (blankD - testTime) +testTime;
            end
        % Flips the Blank Screen after 2 seconds
        DrawFormattedText(w, '','center', 'center', WhiteIndex(w));
        time2flip = isi.VBLTimestamp + testTime2 -ifi; isi2.VBLTimestamp=Screen('Flip',w,time2flip);
        
       
        N2=2;
        N3=3;
        score = 0;
        
        % For 2 N-Back as it needs to look at values which are two steps
        % behind
         if trials>=3
             
              % Calculating response accuracy for 2-N block and 3-N Block,
              % Case 1 takes 2-N block, Case 2 takes 3-N block
                  switch blocks
                      case 1
                         
                           %1 means Same, 0 means Not Same
                            isNum = rem(blockstim(trials-N2,2),2)==0;
                            isCurr = rem(blockstim(trials,2),2)==0;
                            isScore = (isNum == isCurr);
                            
                                if resp(1)==isScore
                                    score = 1;
                                   
                                else 
                                    score =0;
                                end
                      
                      case 2
                          
                           %For 3 N-Back as it needs to look at values
                           %which are two steps are behind
   
                          if trials >= 4
                              
                         %1 means Same, 0 means Not Same
                            isNum = rem(blockstim(trials-N3,2),2)==0;
                            isCurr = rem(blockstim(trials,2),2)==0;
                            isScore = (isNum == isCurr);
                            
                                if resp(1)==isScore
                                    score = 1;
                                   
                                else 
                                    score =0;
                                end
                          end
                  end
         end   
                  
        %%Duration Checks
        fixationCh = pre_instruct.VBLTimestamp - trialstart.VBLTimestamp -ifi;
        stimulusCh = stim.VBLTimestamp-pre_instruct.VBLTimestamp - ifi;
        blankCh1 = isi.VBLTimestamp-stim.VBLTimestamp-ifi;
        blankCh2 = isi2.VBLTimestamp - isi.VBLTimestamp;
        ttimeBlank = blankCh1 +  blankCh2;
        
         
 %Test Output       
  output(blocktrialstarts(blocks)+trials-1,:)=[ nbackType blockstim(trials,2) score resp(2) stimulusCh];
%   
%   % Test save
%   save('testing','output','-ASCII');
  

    end
    
   %% SAVE OUTPUT AFTER EACH BLOCK
   save([num2str(id) '_' num2str(day_stamp) '_' num2str(time_stamp)],'output','-ASCII');


end
Screen('CloseAll');
clear Screen
ShowCursor;
fclose('all');
Priority(0);
