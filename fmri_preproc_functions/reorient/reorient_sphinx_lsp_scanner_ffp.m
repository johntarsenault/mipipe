function reorient_lsp_to_sphinx_scanner_ffp(input_file, output_file, params)


if ~exist(input_file)
    error(sprintf('bash bash_reorient_sphinx_lsp_scanner_FFP.sh cannot run because % is missing', input_file))
end

command_line_function_call = sprintf('bash %sbash_reorient_sphinx_lsp_scanner_FFP.sh %s %s >out.log',params.shell_script_path, input_file, output_file);
system(command_line_function_call);
