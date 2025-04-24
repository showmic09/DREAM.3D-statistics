function [] = saveD3D_file(directory, filename) 
tic
featureID_dataset='/DataContainers/SyntheticVolumeDataContainer/CellData/FeatureIds';
volumes_dataset='/DataContainers/SyntheticVolumeDataContainer/CellFeatureData/Volumes';
eulerAngle_dataset='/DataContainers/SyntheticVolumeDataContainer/CellFeatureData/EulerAngles';
%file_dir=fullfile(SCS.directory,['Block',num2str(SCS.block_ID),'.dream3d']);
SCS.directory=directory;
SCS.filename=filename;
file_dir=fullfile(SCS.directory,SCS.filename);

%volume=h5read(file_dir,volumes_dataset)'; volume(1)=[]; volume=double(volume);
euler_angles=reshape(h5read(file_dir,eulerAngle_dataset),3,[])'; euler_angles(1,:)=[];
voxelID=permute(h5read(file_dir,featureID_dataset),[2,3,4,1]);
voxelID=double(reshape(voxelID,[],1));
toc

val=unique(voxelID,'sorted');
volume=histc(voxelID,val);
diameter=@(V) (V/(pi/6)).^(1/3);
SCS.R=diameter(max(volume));
SCS.block_dims=round(sum(volume)^(1/3))*[1 1 1];
%SCS.master_dims=SCS.block_dims;

SCS.nGrains=length(volume);
save(['stat_',SCS.filename,'.mat'],'-v7.3')
