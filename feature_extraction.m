clear; close all; clc;
Fs = 15;                 
T = 1/Fs;
ag = zeros(1,34)
gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv'};
features = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};

% FFT
featmat1 = zeros(5400,15);
offset = 1;
datapoint = 1;
fftEx= [15,19,2,24,25];
for feature = 1 : length(fftEx)
    fig = figure('name',char(features(feature)));
    datapoint = 1;
    
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = width(rawData) - 1;
        t = (0:L-1)*T;        
        f = Fs*(0:L/2)/L;
        Y = 0;    
        for i = 0:((height(rawData)/34) - 1)
            input = table2array(rawData(i*34+fftEx(feature),2:end));
            Y = fft(input);        
            P2 = abs(Y/L);
            P1 = P2(1:(L/2+1));
            P1(2:end-1) = 2*P1(2:end-1);          
            temp = sort(P1,'descend');
            for p = 0 :2
                featmat1(datapoint,offset + p) = temp(p+1);         
            end        
            datapoint = datapoint + 1;
        end  
    end
    offset = offset + 3;
end

% DWT
featmat2 = zeros(5400,12);
offset1 = 1;
datapoint1 = 1;
dwtEx = [12,15,19,11];
for feature = 1:length(dwtEx)
    dwtData = {};
    datapoint1 = 1;
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = height(rawData)/34;
        Y = 0;
        for i = 0:(L - 1)
            input = table2array(rawData(i*34+dwtEx(feature),2:end));
            [A,D] = dwt(input,'sym4');
            Y = A;
        
            temp = sort(Y,'descend');
            for p = 0 :2
                featmat2(datapoint1,offset1 + p) = temp(p+1);           
            end             
            datapoint1 = datapoint1 + 1;
            
        end
    end
    offset1 = offset1 + 3;
end

%rms
rmsEx = [23,24,25,26,27];
featmat3 = zeros(5400,5);
datapoint2 = 1;
for feature = 1:length(rmsEx)
    id = zeros(1,10);
    datapoint2 = 1;
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        a = 0.0;
        for i = 0:((height(rawData)/34) - 1)
            input = table2array(rawData(i*34+rmsEx(feature),2:end));
            a = rms(input);
            featmat3(datapoint2,feature) = a;                     
            datapoint2 = datapoint2 + 1;          
        end     
    end  
end

%variance
varianceEx = [24,25,26,27,28,23,22,15,21,14];
featmat4 = zeros(5400,10);
datapoint3 = 1;
for feature = 1:length(varianceEx)
    id = zeros(1,10);
    datapoint3 = 1;
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        a = 0.0;
        for i = 0:((height(rawData)/34) - 1)
            input = table2array(rawData(i*34+varianceEx(feature),2:end));
            a = var(input);
            featmat4(datapoint3,feature) = a;                     
            datapoint3 = datapoint3 + 1;          
        end     
    end  
end
pnewf = [11,7,8,18,12,20,14,9,16,10];
featmat5 = zeros(5400,10);
datapoint = 1
for feature = 1:length(pnewf)
    %fig = figure('name',char(features(feature)));
    datapoint = 1;
    for gesture = 1:length(gestures)
        rawData = readtable(char(gestures(gesture)));
        L = height(rawData)/34
        Y = 0;
        
        for i = 0:(L - 1)
            input = table2array(rawData(i*34+pnewf(feature),2:end));
            Y = pspectrum(input,1024);
            psd = dspdata.psd(Y,'Fs',Fs);
            k = max(psd.Data)
            featmat5(datapoint,feature) = k;                     
            datapoint = datapoint + 1;
            
        end
        %Y = Y/L
        %{
        subplot(2,5,gesture) 
        plot(psd)
        title(gestures(gesture));
        %}
    end
    %saveas(fig,strcat('PSD_',char(features(feature)),'.jpg'));
end
f1 = horzcat(featmat1,featmat2);
f2 = horzcat(featmat3,featmat4);
final = horzcat(f1,f2);
final2 = horzcat(final,featmat5)



