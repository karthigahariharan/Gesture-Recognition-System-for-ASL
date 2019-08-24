clear; close all; clc;
Fs = 15;                 
T = 1/Fs;
gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go_out.csv','hearing.csv'};
features = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};
indexes=[15,9,2,24,25]
for feature = 1:5
    fig = figure('name',char(features(indexes(feature))));
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = width(rawData) - 1;
        t = (0:L-1)*T;        
        f = Fs*(0:L/2)/L;
        Y = 0;
        for i = 0:((height(rawData)/34) - 1)
            input = table2array(rawData(i*34+indexes(feature),2:end));
            Y = fft(input);
        end
        P2 = abs(Y/L);
        P1 = P2(1:(L/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        subplot(2,5,gesture) 
        plot(f,P1)
            
    end
    title(gestures(gesture));
    saveas(fig,strcat('FFT_',char(features(indexes(feature))),'.jpg'));
end