function [fix_no ima_no] = get_ima_log_pairs_from_elab_pdf(pdf_file_name)


%start and end table strings must be in regexp format
%therefore with escape characters before meta characters 
%(e.g. '(' becomes '\('
start_table_string = 'Fixation \(#\)';
end_table_string = 'Unique eLabID';

%read in pdf and combine pages
pdf_text = pdfRead(pdf_file_name);
pdf_text_combined = strjoin(pdf_text(:));

%remove comments from table
[startIndex, endIndex] = regexp(pdf_text_combined, '\{(.*?)\}');

for i_brackets_to_remove = numel(startIndex):-1:1
    pdf_text_combined(startIndex(i_brackets_to_remove):endIndex(i_brackets_to_remove)) = [];
end

%remove text before and after table
[startIndex, endIndex] = regexp(pdf_text_combined, sprintf('%s(.*?)%s',start_table_string,end_table_string));
pdf_text_combined(endIndex-12:end) = [];
pdf_text_combined(1:startIndex-1) = [];


%save table as a text file
pdf_file_parts = fileparts_full(pdf_file_name);
pdf_txt_file_name = [pdf_file_parts.path, pdf_file_parts.file,'.txt'];

fid = fopen(pdf_txt_file_name, 'w');
fwrite(fid, pdf_text_combined);
fclose(fid);

%read in table text file
%find the ima log letter pairs
clear fix_no ima_no log_alpha
fix_no = [];
ima_no = [];
log_alpha = {};
fid = fopen(pdf_txt_file_name);

tline = fgetl(fid);

while ischar(tline)
    split_line = strsplit(tline);
    if numel(split_line) > 2
        if all(isstrprop(split_line{1}, 'digit')) & all(isstrprop(split_line{3}, 'alpha'))
            disp([split_line{1}, ' ', split_line{6}]);
            fix_no = [fix_no str2num(split_line{6})];
            ima_no = [ima_no str2num(split_line{1})];
            log_alpha{end+1} = split_line{3};
        end
    end
    tline = fgetl(fid);
    
end