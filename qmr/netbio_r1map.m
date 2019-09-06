% V1 = spm_vol(spm_select);
T1 = spm_read_vols(V1);
T1(T1==0) = NaN;

%%
R1 = (1./T1);
R1(R1>1.5) = 0;
imagesc(rot90(squeeze(R1(:,:,60)))); 
axis square
V1.fname = 'R1.nii';
V1.private.dat.fname = V1.fname;
spm_write_vol(V1,R1);