clear all;
clc;
close all


% to get the same and sample numbers on a serial list

[both_CD31, both_CA9] = setup_image_files();

for j = 1:size(both_CA9,2)
    s_names{j} = both_CA9{j}.name;
end

temp_table = table;

serial_numbers = 1:58;

temp_table.SerialNumbers = serial_numbers';
temp_table.SampleName = s_names';


writetable(temp_table,'SampleNamesOrder.txt','Delimiter',' ')  