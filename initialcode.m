guestures={'about','and'}
dir1 = 'D:\DM\data';
subfolder=dir(dir1);
tf = ismember( {subfolder.name}, {'.', '..'});
subfolder(tf) = [];

for j=1:numel(guestures)
    tabletowrite=table;
    for l=1:numel(subfolder)
        pattern='*.csv';
        newpattern=strcat(guestures{j},pattern);
        guesturefile = fullfile(dir1,subfolder(l).name,newpattern);
        d = dir(guesturefile);
        sensors={'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG3L','EMG4L','EMG5L','EMG6L','EMG7L','EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'}
        for k=1:numel(d)
            filename=fullfile(dir1,subfolder(l).name,d(k).name)
            value=readtable(filename,'Delimiter',',');
            firstcolvalue={};
            for i=1:34
                firstcolvalue{i,1}="Action"+k+"-"+sensors(i);
            end
            initialcol=cell2table(firstcolvalue);
            rowlength=height(value)
            if rowlength==45
                trimmedvalues=table2array(value(1:45,1:34))
            elseif rowlength<45&&rowlength>37
                trimmedvalues=table2array(value(:,1:34))
                trimmedvalues=padarray(trimmedvalues,[45-rowlength,0],0,'post');
            else
                continue
            end
            trimmedvalues=trimmedvalues';
            tableout=array2table(trimmedvalues);
            finaltable=[initialcol tableout];
            tabletowrite=vertcat(tabletowrite,finaltable);
        end
    end
    filevalue=strcat(guestures{j},".csv");
    writetable(tabletowrite,filevalue,'WriteVariableNames', false)
end
