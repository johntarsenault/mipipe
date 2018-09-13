function params = reorient_sphinx_single(input, params)

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end


gre_masked_parts = fileparts_full(params.gre_masked);
params.gre_masked_reoriented = fullfile(mask_dir, [gre_masked_parts.file, '_mean', gre_masked_parts.ext]);


if ~exist(params.gre_masked)
    error(sprintf('bash reorient_to_sphinx.sh cannot run because % is missing', params.gre_masked))
end

command_line_function_call = sprintf('bash %sbash_reorient_sphinx.sh %s %s %s %s >out.log',params.shell_script_path, params.gre_masked, params.gre_masked_reoriented, params.gre_in_orientation, params.gre_out_orientation);
system(command_line_function_call);
