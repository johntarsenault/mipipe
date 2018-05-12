function reorient_lsp_to_sphinx(input_file, output_file, params)


if ~exist(input_file)
    error(sprintf('bash reorient_lsp_to_sphinx.sh cannot run because % is missing', input_file))
end

command_line_function_call = sprintf('bash %sbash_reorient_sphinx_lsp.sh %s %s',params.shell_script_path, input_file, output_file);
system(command_line_function_call);
