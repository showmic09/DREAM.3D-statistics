%3 inputs are required. The function assumes that the single-phase blocks
%are located within some folders inside the desired directory. sd_val
%represents the distribution width (Standard Deviation). Modification is 
%done by Showmic at 4/25/2023. 
function[]= dream3d_block_stat_within_folder(directory,sd_val,filename)
% d=dir(directory);
% isub = [d(:).isdir]; %# returns logical vector
% nameFolds = {d(isub).name}';
% nameFolds(ismember(nameFolds,{'.','..'}))=[];
diameter=@(volume) (volume./(pi/6)).^(1/3);
counter=1;
featureID_dataset='/DataContainers/SyntheticVolumeDataContainer/CellData/FeatureIds';
volumes_dataset='/DataContainers/SyntheticVolumeDataContainer/CellFeatureData/Volumes';
eulerAngle_dataset='/DataContainers/SyntheticVolumeDataContainer/CellFeatureData/EulerAngles';
if(counter<31)
    for ii=1:30%length(nameFolds)
        cd(fullfile(directory,num2str(ii)));
        path=pwd
        d2=dir(filename);
        if(length(d2.name) >=1)
            %file_dir=['sd_',num2str(sd_val),'_cubic.dream3d'];
            %file_dir=dir('*.dream3d');
            file_dir=d2(1).name
            %filename=['sd_',num2str(sd_val),'_cubic.dream3d'],
            tic
            volume=h5read(file_dir,volumes_dataset)'; volume(1)=[]; volume=double(volume);
            euler_angles=reshape(h5read(file_dir,eulerAngle_dataset),3,[])'; euler_angles(1,:)=[];
            voxelID=permute(h5read(file_dir,featureID_dataset),[2,3,4,1]);
            voxelID=double(reshape(voxelID,[],1));
            toc
            val=unique(voxelID,'sorted');
            volume=histc(voxelID,val);
            dia=diameter(volume);
            dia_block{counter}=dia;
            num_grain(counter)=numel(volume);
            mean_dia(counter)=mean(dia);
            var_dia(counter)=var(dia);
            counter=counter+1;
        end
    end
end
cd ..;
num_blocks=counter-1;
mean_block=mean(mean_dia);
mean_var_block=mean(var_dia);
std_block=sqrt(mean_var_block);
mean_grain=mean(num_grain);
sd_grain=std(num_grain);
save(['data_gauss',num2str(sd_val),'_stat'],'mean_dia','var_dia','num_blocks','mean_block','std_block','mean_grain','sd_grain','dia_block');
counter=1;
clear 'dia_block' 'num_grain' 'mean_dia' 'var_dia'
end
