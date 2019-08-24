clear; close all; clc;
Fs = 15;                 
gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go_out.csv','hearing.csv'};
features = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};
corr_coeff = [];
for feature = 1:length(features)
    dwtData = {};
    %{fig = figure('name',char(features(feature)));
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = height(rawData)/34;
        Y = 0;
        for i = 0:(L - 1)
            input = table2array(rawData(i*34+feature,2:end));
            [A,D] = dwt(input,'sym4');
            Y = Y + A;
        end
        Y = Y/L;
        dwtData = [dwtData;Y];
        %subplot(2,5,gesture) 
        %plot(Y)
        title(gestures(gesture));
    end
    %saveas(fig,strcat('DWT_',char(features(feature)),'.jpg'));
    coeff = 0;
    for a = 1:length(gestures)
        for b = (a+1):length(gestures)
            signal1 = dwtData{a};
            signal2 = dwtData{b};
            R = corrcoef(signal1,signal2);
            coeff = coeff + R(2);
        end
    end
    corr_coeff = horzcat(corr_coeff,coeff);    
end
[coeffValue,featureIndex] = sort(corr_coeff,'ascend') 
disp(features(featureIndex))
