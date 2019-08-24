clear; close all; clc;
Fs = 15;                 
gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv'};
features = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};
indexes=[11,7,8,18,12];
for feature = 1:5
    fig = figure('name',char(features(indexes(feature))));
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = height(rawData)/34;
        Y = 0;
        for i = 0:(L - 1)
            input = table2array(rawData(i*34+indexes(feature),2:end));
            Y = Y + pspectrum(input,1024);
        end
        Y = Y/L;
        %h=spectrum.welch;
        psd = dspdata.psd(Y,'Fs',Fs);
        plot(psd)
        hold on;
        legend('about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv');
    end
    hold on;
    saveas(fig,strcat('PSD_var',char(features(indexes(feature))),'.jpg'));
end