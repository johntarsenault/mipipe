function params = apply_coregister_4D_ants_preproc(input_file, output_file, params)



unix_command = sprintf('antsApplyTransforms --default-value 0 --dimensionality 3 -e 3 -i %s --interpolation BSpline -o %s  --reference-image %s  --transform %s --transform [%s,0] >out.log',input_file,output_file,params.template,params.b_spline_warp_transform,params.affine_transform);

system(unix_command);

