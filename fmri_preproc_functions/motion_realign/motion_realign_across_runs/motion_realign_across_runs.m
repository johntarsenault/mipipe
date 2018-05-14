function inter_run_nonlinmc(input_file,output_file,params)


%disp('reading target volume...')
ITARG=MRIread(params.mean_target);
%disp('reading movable volume...')
IMOV=MRIread(input_file);


Imoving = mean(IMOV.vol,4);
Istatic = ITARG.vol;

Nx   = size(IMOV.vol,1); 
Ny   = size(IMOV.vol,2); 
Nsl  = size(IMOV.vol,3);
Nvol = size(IMOV.vol,4);


% slice-by-slice interrun undistortion correction 
Options.Similarity='sd'; 
Options.Registration='Both';
Options.Interpolation='Linear';
Options.Verbose=0;
Options.MaxRef=1;
Options.Penalty=1e-5;


Iundist=zeros(Nx,Ny,Nsl,Nvol);
%disp('running registration...')
     
[~,mat,spacing] = image_registration(Imoving,Istatic,Options);


for vol=1:Nvol
    
    Iundist(:,:,:,vol)=bspline_transform(mat,squeeze(IMOV.vol(:,:,:,vol)),spacing,3);     
    
end



IMOV.vol = Iundist;
MRIwrite (IMOV, [output_file]);


return
