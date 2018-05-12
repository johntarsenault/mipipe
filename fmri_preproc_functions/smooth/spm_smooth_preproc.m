function spm_smooth_preproc(input_file,output_file,params)

for i_tr_no = 1:params.tr_no    
    matlabbatch{1}.spm.spatial.smooth.data{i_tr_no,1} = sprintf('%s,%d',input_file,i_tr_no);
end


matlabbatch{1}.spm.spatial.smooth.fwhm = [repmat(params.smooth.fwhm,1,3)];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

spm_jobman('initcfg');
spm_jobman('run',matlabbatch);

input_parts = fileparts_full(input_file);

movefile([input_parts.path,matlabbatch{1}.spm.spatial.smooth.prefix,input_parts.file,input_parts.ext],output_file);