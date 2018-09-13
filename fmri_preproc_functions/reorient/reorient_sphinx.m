function reorient_sphinx(input_file, output_file, params)


if ~exist(input_file)
    error(sprintf('bash reorient_to_sphinx.sh cannot run because % is missing', input_file))
end

command_line_function_call = sprintf('bash %sbash_reorient_sphinx.sh %s %s %s %s >out.log',params.shell_script_path, input_file, output_file, params.gre_in_orientation, params.gre_out_orientation);
system(command_line_function_call);
