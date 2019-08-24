clear; close all; clc;
Fs = 15;                 
T = 1/Fs;
corr_coeff=[];
gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go_out.csv','hearing.csv'};
features = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};

for feature = 1:length(features)
    FFT = {};
    %fig = figure('name',char(features(feature)));
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = width(rawData) - 1;
        t = (0:L-1)*T;        
        f = Fs*(0:L/2)/L;
        Y = 0;
        for i = 0:((height(rawData)/34) - 1)
            input = table2array(rawData(i*34+feature,2:end));
            Y = Y + fft(input);
        end
        P2 = abs(Y/L)/(i+1);
        P1 = P2(1:(L/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        FFT = [FFT;P1];
        %subplot(2,5,gesture) 
        %plot(f,P1)
        %title(gestures(gesture));
    end
    coeff = 0;
    for a = 1:length(gestures)
        for b = (a+1):length(gestures)
            signal1 = FFT{a};
            signal2 = FFT{b};
            sx = size(signal1);
            sy = size(signal2);
            if sx(2) ~= sy(2)
                m = max(sx(2), sy(2));
                if sx(2) ~= m
                    signal1 = [signal1 zeros(abs([0 m]-sx))];
                else
                    signal2 = [signal2 zeros(abs([0 m]-sy))];
                end
            end
            R = corrcoef(signal1,signal2);
            coeff = coeff + R(2);
        end
    end
    %temp=[char(features(feature), coeff]
    corr_coeff = horzcat(corr_coeff,coeff);
    
    %saveas(fig,strcat('FFT_',char(features(feature)),'.jpg'));
end
[coeffValue,featureIndex] = sort(corr_coeff,'ascend')
%corr_coeff=sort(corr_coeff,'ascend');
disp(features(featureIndex))

