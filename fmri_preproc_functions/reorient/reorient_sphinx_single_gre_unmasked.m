function params = reorient_sphinx_single_gre_unmasked(input, params)

%build mask dir if not already created
mask_dir = fullfile(params.base_dir, '/funct/mask/');
if ~exist(mask_dir)
    mkdir(mask_dir)
end


gre_parts = fileparts_full(params.gre);
params.gre_reorient = fullfile(mask_dir, [gre_parts.file, '_reorient', gre_parts.ext]);


if ~exist(params.gre)
    error(sprintf('bash reorient_to_sphinx.sh cannot run because % is missing', params.gre))
end

command_line_function_call = sprintf('bash %sbash_reorient_sphinx.sh %s %s %s %s >out.log',params.shell_script_path, params.gre, params.gre_reorient, params.gre_in_orientation, params.gre_out_orientation);
system(command_line_function_call);
