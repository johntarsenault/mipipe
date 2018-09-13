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
    %delete(output_file_mean_tsnr{i_runs});
end

mean_median_distance_index = zeros(1,numel(input.file_list));
mean_outlier_detection = zeros(1,numel(input.file_list));

%run quality assesment
parfor i_runs = 1:numel(input_file)
    [mean_median_distance_index(i_runs) mean_outlier_detection(i_runs)] = preproc_quality_assessment_single(input_file{i_runs}, output_file_mean{i_runs}, output_file_std{i_runs}, output_file_tsnr{i_runs}, output_file_mean_tsnr{i_runs}, functional_mask);
end

%get image number info
image_info = regexpi(input.file_list, '(?<Monkey>\w+)_IMA_(?<Number>\d+).nii', 'names');
ima_names = cellfun(@(x) sprintf('IMA %s',x.Number),image_info,'UniformOutput',false);


%get mean tsnr
mean_tsnr_text = {};
for i_runs = 1:numel(output_file_mean_tsnr)
        mean_tsnr_text{i_runs} = fileread(output_file_mean_tsnr{i_runs});
end
mean_tsnr = str2double(mean_tsnr_text);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_oneVal_perRun(mean_tsnr,'mean_tsnr',qa_dir,ima_names);
plot_oneVal_perRun(mean_median_distance_index,'mean_median_distance_index',qa_dir,ima_names);
plot_oneVal_perRun(mean_outlier_detection,'mean_outlier_detection',qa_dir,ima_names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_image_name = dir(fullfile(qa_dir,'*_mean.nii'));
mean_image_no = numel(mean_image_name);


for i_runs = 1:mean_image_no
    current_image =MRIread(fullfile(qa_dir,mean_image_name(i_runs).name));
    image_1D(:,i_runs) = reshape(current_image.vol,1,numel(current_image.vol));
end

dissimiliarity_matrix = 1 - corr(image_1D);
diss_round            = round(dissimiliarity_matrix,10);
[Y,eigvals] = cmdscale(diss_round);

%Dtriu = dissimiliarity_matrix(find(tril(ones(mean_image_no),-1)))';
%maxrelerr = max(abs(Dtriu-pdist(Y(:,1:2))))./max(Dtriu);

nameList = {mean_image_name.name};
image_info = regexpi(nameList, '(?<Monkey>\w+)_IMA_(?<Number>\d+)_mean.nii', 'names');
ima_names = cellfun(@(x) sprintf('IMA %s',x.Number),image_info,'UniformOutput',false);

figure;
set(gcf,'position',[680 121 1238 963]);
plot(Y(:,1),Y(:,2),'.');
text(Y(:,1),Y(:,2),ima_names);
title('MDS of mean images');

saveas(gcf,[qa_dir,'qa_mds_meanImages.png']);
close(gcf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[maxVal maxID] = max(mean_tsnr);



