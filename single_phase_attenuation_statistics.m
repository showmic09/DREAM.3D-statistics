% The code is written for a SLURM environment. The function defines 
% the basic properties for calculating attenuation from a DREAM.3D volume
function[] = single_phase_attenuation_statistics(slurm_array)
addpath('/home/jaturner/showmic/voxelized_attenuation_code/');
SCS.block_dims=780*[1 1 1];
SCS.directory='/work/jaturner/showmic/texture_TMS/cube/sd6/'; %%change here
SCS.material='Ni';
SCS.avg_type='voigt';
SCS.resolution=[1 1 1];
SCS.p=[0.5 0.7071 0.5]; % propagation direction
SCS.nPairs=5e4; % Number of pairs for each separation vector
SCS.nFT=5e3; % Number of separation vectors required for the Fourier transform of the covariance function
SCS.nScatt=1000; % Number of scattering directions
freq_array=[7.5 10 15 20 25 30 35 40 45 50];
SCS.freq= freq_array(slurm_array);
result_path=['/work/jaturner/showmic/texture_TMS/results/cube/angle45/sd6/freq_',num2str(SCS.freq),'_MHz']; % Results are saved here
mkdir(result_path)
grainID_path=fullfile(result_path,'grainID');

for ii=1:30
    	direc=fullfile(SCS.directory,num2str(ii))
    	cd(direc);
    	d=dir('*cropped.dream3d');
    	numel(d)
        if(numel(d)>0)
            SCS.directory=direc;
            SCS.block_ID=ii;
            d(1).name
            SCS.filename=d(1).name;
            attenuation_decoupled_sectioned(SCS,result_path);
            disp('in');
        end
	SCS.directory='/work/jaturner/showmic/texture_TMS/cube/sd6/';  %%%%%change here
end
end
