function [fix_string] = align_fixation_to_ima(fix_no,ima_no,ordered_json_files)
% Get IMA number from json files
for json_files = 1:length(ordered_json_files);
    IMA_Index(json_files) = strfind(ordered_json_files{json_files},'IMA');
    IMA_string{json_files} = ordered_json_files{json_files}(IMA_Index:IMA_Index+6);
    IMA_Numb(json_files) = str2num(IMA_string{json_files}(regexp(IMA_string{json_files},'\d')));
end

% Delete IMA/fixations that are not in the IMA numbers
Wrong_IMAs = setdiff(ima_no,IMA_Numb);
Wrong_ind  = find(ima_no == Wrong_IMAs);
fix_no(Wrong_ind) = [];
ima_no(Wrong_ind) = [];

for fix = 1:length(fix_no);
fix_string{fix} = num2str(fix_no(fix));
end
    
% Check whether length is the same
if length(fix_no) ~= length(IMA_Numb);
    error('Length of fixation runs and IMAs is not the same, something wrong!');
end