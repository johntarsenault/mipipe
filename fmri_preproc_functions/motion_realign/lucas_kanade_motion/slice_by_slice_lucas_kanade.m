function regressor_name = slice_by_slice_within_run(input_file, output_file, params)

%% preprocess monkey fMRI data - slice by slice motion correction

% input_file = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423/funct/_1_source_data/Tank180423_IMA_26.nii';
% output_file = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423/funct/_1_source_data/u_Tank180423_IMA_26.nii';
% params.mask = '/mnt/.autofs/storage/gbw-s-neu01_fmri-monkey-03/PROJECT/Sjoerd/FaceBody_Discrimination/fMRI/daily_fMRI_results/tank180423/funct/mask/Tank180423_IMA_26_r_st_brain_mask.nii';


regressor_dir = [params.base_dir, '/funct/regressor/slice_by_slice_lucas_kanade/'];

if ~exist(regressor_dir)
    mkdir(regressor_dir);
end



val = 10; % value for Nbasis to find closest divisor
niter = 8; % number of iterations
mask_norm_val = 0.1; % normalization value for masking
refvol = 1; %reference volume for LucasKanade motion correction



    %     select session EPI

    V_epi = spm_vol(input_file);
    V_mask = spm_vol(params.dilate_smooth);

    epi = spm_read_vols(V_epi);
    mask_vol = spm_read_vols(V_mask);

    mask_norm = mask_vol;
    mask_norm(mask_vol < mask_norm_val) = mask_norm_val;
    
    epi_c = epi;
    epi_c = epi_c .* repmat(mask_norm, [1, 1, 1, size(epi, 4)]);
    [xdim, ydim, zdim, tdim] = size(epi); % save original dimensions
    
    %     run LucasKanade motion correction within each session
    
    for i = 1:size(epi, 3)
        fprintf('slice : %d \n', i)
        for j = 2:size(epi, 4)
            [dummy, ~, ~] = doLucasKanadeMRI(epi_c(:, :, i, refvol)', epi_c(:, :, i, j)', val, niter);
            epi_c(:, :, i, j) = dummy';
        end
    end
    
    %divide by mask to get back to original values
    %OPTIONAL
    %        epi_c=epi_c./repmat(mask_norm,[1 1 1 size(epi,4)]);
    
    
    %     save motion corrected volume as NIFTI with prefix
    path_epiC = [output_file];
    epiC_name = sprintf('%s', path_epiC);
    
    V_epiC = V_epi;
    for i = 1:length(V_epiC)
        V_epiC(i).fname = epiC_name;
        spm_write_vol(V_epiC(i), epi_c(:, :, :, i));
    end
    
    
    % statistics on noise reduction
    target_image_pre = squeeze(epi(:, :, :, refvol));
    target_image_post = squeeze(epi_c(:, :, :, refvol));
    
    corr_pre = zeros(1, tdim);
    corr_post = zeros(1, tdim);
    for k = 1:tdim
        im_pre = squeeze(epi(:, :, :, k));
        im_post = squeeze(epi_c(:, :, :, k));
        corr_pre(k) = corr(target_image_pre(mask_vol == 1), im_pre(mask_vol == 1));
        corr_post(k) = corr(target_image_post(mask_vol == 1), im_post(mask_vol == 1));
    end
    mean_corrpost = mean(corr_post);
    
    image_filename = sprintf('%s_Nbasis%02d_masknorm%.2f_stats.tif', path_epiC(1:end-4), Nbasis, mask_norm_val);
    regressor_filename = sprintf('%s_Nbasis%02d_masknorm%.2f_stats.mat', path_epiC(1:end-4), Nbasis, mask_norm_val)
    regressor_filename_txt = sprintf('%s_Nbasis%02d_masknorm%.2f_stats.txt', path_epiC(1:end-4), Nbasis, mask_norm_val)

    figure;
    plot(corr_pre);
    hold on;
    plot(corr_post, 'r');
    ylim([0.5, 1])
    legend('before correction', 'after correction', 'Location', 'southwest');
    title(sprintf('mean correlation post correction: %.4f', mean_corrpost));
    print(image_filename, '-dtiff', '-r150');
    close(gcf);

    save(regressor_filename, 'corr_pre', 'corr_post');
    dlmwrite(regressor_filename_txt,1-corr_pre');
    
    fprintf('\n')
    
    image_filename_parts = fileparts_full(image_filename);
    regressor_filename_parts = fileparts_full(regressor_filename);
    regressor_filename_txt_parts = fileparts_full(regressor_filename_txt);

    movefile(image_filename, regressor_dir);
    movefile(regressor_filename, regressor_dir);
    movefile(regressor_filename_txt, regressor_dir);

    
    regressor_name = {'motion_regressor',[regressor_dir,regressor_filename_txt_parts.file,regressor_filename_txt_parts.ext]};

