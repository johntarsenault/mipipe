function params = preproc_combine_gre(input, params)


%get name of gre files
gre_name = dir(fullfile(params.base_dir,params.gre_dir,'*_IMA_*nii'));
gre_name_list = {gre_name.name};

%find the beginning of the file name

IMA_number_stop = cellfun(@(x) findstr(x,'IMA'),gre_name_list) + 5;
IMA_number_stop_cell = num2cell(IMA_number_stop);

%extract the beginning of the name
root_names = cellfun(@(name,stop) name(1:stop), gre_name_list, IMA_number_stop_cell,'UniformOutput', false);
root_names = categorical(root_names);

%find number of name instances
root_name_no = zeros(1,numel(root_names));
for i_names = 1:numel(root_names)
    root_name_no(i_names) = numel(find(root_names == root_names(i_names)));
end

%get unique images; 
single_run_IDX = find(root_name_no == 1);
unique_gre_names = gre_name_list(single_run_IDX);

%build full filename
build_name_anon = @(x) fullfile(params.base_dir,params.gre_dir,x);
full_unique_gre_names = cellfun(@(x) build_name_anon(x),unique_gre_names,'UniformOutput', false);

%initialize a volume
initial_file = MRIread(full_unique_gre_names{1});
combined_gre_vol = zeros(size(initial_file.vol));

%loop through volumes and add; then calculate the mean
for i_gre = 1:numel(full_unique_gre_names)
    current_image = MRIread(full_unique_gre_names{i_gre});
    combined_gre_vol = combined_gre_vol + current_image.vol;
end
combined_gre_vol = combined_gre_vol ./ numel(full_unique_gre_names);

%write out mean volume
initial_file.vol = combined_gre_vol;
combined_gre_file_name = fullfile(params.base_dir,params.gre_dir,'combined_gre_image.nii');
MRIwrite(initial_file,combined_gre_file_name)
params.gre = combined_gre_file_name;