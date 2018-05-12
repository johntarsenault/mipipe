function [output] = fileparts_full(fullfile)

[output.path output.file output.ext] = fileparts(fullfile);
output.path = [output.path,'/'];

end

