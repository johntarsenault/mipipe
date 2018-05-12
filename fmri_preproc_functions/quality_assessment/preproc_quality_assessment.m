function  maxID = preproc_quality_assessment(input, functional_mask, params)

%make quality assessment directory
qa_dir = [params.base_dir,'/funct/_1_quality_assessment/'];    
if ~exist(qa_dir)
    mkdir(qa_dir);
end

%make a mean_tsnr subdirectory
if ~exist([qa_dir,'/mean_tsnr/'])
    mkdir([qa_dir,'/mean_tsnr/']);
end

%build names of files input and ouputs
for i_runs = 1:numel(input.file_list)
    input_file{i_runs} = [params.base_dir,input.dir,input.file_list{i_runs}];
    input_file_parts = fileparts_full(input_file{i_runs});

    output_file_mean{i_runs} = [qa_dir,input_file_parts.file,'_mean',input_file_parts.ext];
    output_file_std{i_runs} = [qa_dir,input_file_parts.file,'_std',input_file_parts.ext];
    output_file_tsnr{i_runs} = [qa_dir,input_file_parts.file,'_tsnr',input_file_parts.ext];

    output_file_mean_tsnr{i_runs} = [[qa_dir,'/mean_tsnr/'],input_file_parts.file,'_tsnr.txt'];
end

%run quality assesment
parfor i_runs = 1:numel(input_file)
    preproc_quality_assessment_single(input_file{i_runs}, output_file_mean{i_runs}, output_file_std{i_runs}, output_file_tsnr{i_runs}, output_file_mean_tsnr{i_runs}, functional_mask);
end

mean_tsnr_text = {};
for i_runs = 1:numel(output_file_mean_tsnr)
        mean_tsnr_text{i_runs} = fileread(output_file_mean_tsnr{i_runs});
end

mean_tsnr = str2double(mean_tsnr_text);

figure('visible','off');
set(gcf,'Position',[56         316        1791         735]);
plot([1:numel(mean_tsnr)],[mean_tsnr],'LineWidth',2,'Color',[.2 .2 .2]);
ylabel('temporal SNR');
xticks([1:numel(mean_tsnr)]);
xticklabels({1:numel(mean_tsnr)});
xlabel('run #');
xlim([.5 numel(mean_tsnr)+.5]);
saveas(gcf,[qa_dir,'mean_tsnr_across_runs.png']);
close(gcf);

[maxVal maxID] = max(mean_tsnr);



